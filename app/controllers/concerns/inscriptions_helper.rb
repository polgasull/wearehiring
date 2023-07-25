# frozen_string_literal: true

module InscriptionsHelper

  def assign_inscription_to_job(job, user, route, added_by_company)
    return redirect_back_response(t('already_inscribed'), false) if user.is_already_inscribed(job)
      
    @inscription = job.inscriptions.build(job_id: job.id, user_id: user.id, added_by_company: added_by_company)

    begin
      location_info = Geocoder.search(user.last_sign_in_ip).first
      
      user.transaction do
        user.update!(
          resident_city: location_info.city,
          resident_state: location_info.state,
          resident_country: location_info.country,
          resident_country_code: location_info.country_code,
          resident_postal_code: location_info.postal_code
        )
      end if !added_by_company
    rescue Geocoder::OverQueryLimitError => e
      sleep(5)
  
      Rails.logger.error("Geocoder request limit exceeded: #{e.message}")
  
      user.update!(
        resident_city: '',
        resident_state: '',
        resident_country: '',
        resident_country_code: '',
        resident_postal_code: ''
      )
    else
      Rails.logger.info("User resident information updated successfully.")
    end
    
    if @inscription.save
      ModelMailer.successfully_inscribed(user, job).deliver_later
      DiscordService.new.inscription_alert_webhook(user, job, added_by_company)

      if (job.is_free_price? && job.inscriptions.count >= 15)
        return redirect_to_response(t('inscriptions.messages.inscription_created'), route ? route : job)
      end
      
      ModelMailer.new_candidate(user, job).deliver_later
      redirect_to_response(t('inscriptions.messages.inscription_created'), route ? route : job)
    else
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end
end
