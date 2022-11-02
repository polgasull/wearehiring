# frozen_string_literal: true

module InscriptionsHelper

  def assign_inscription_to_job(job, user, route, added_by_company)
    return redirect_back_response(t('already_inscribed'), false) if user.is_already_inscribed(job)
      
    @inscription = job.inscriptions.build(job_id: job.id, user_id: user.id, added_by_company: added_by_company)

    user.transaction do
      user.update!(resident_city: Geocoder.search(user.current_sign_in_ip).first.city)
      user.update!(resident_state: Geocoder.search(user.current_sign_in_ip).first.state)
      user.update!(resident_country: Geocoder.search(user.current_sign_in_ip).first.country)
      user.update!(resident_country_code: Geocoder.search(user.current_sign_in_ip).first.country_code)
      user.update!(resident_postal_code: Geocoder.search(user.current_sign_in_ip).first.postal_code)
    end
    
    if @inscription.save
      unless (job.is_free_price? && job.inscriptions.count >= 15)
        ModelMailer.new_candidate(user, job).deliver_later
      end
      ModelMailer.successfully_inscribed(user, job).deliver_later
      DiscordService.new.inscription_alert_webhook(user, job, added_by_company)
      redirect_to_response(t('inscriptions.messages.inscription_created'), route ? route : job)
    else
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end
end
