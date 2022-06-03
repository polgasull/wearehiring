# frozen_string_literal: true

module InscriptionsHelper

  def assign_inscription_to_job(job, user, route, added_by_company)
    return redirect_back_response(t('already_inscribed'), false) if user.is_already_inscribed(job)
      
    @inscription = job.inscriptions.build(job_id: job.id, user_id: user.id, added_by_company: added_by_company)
    
    if @inscription.save  
      ModelMailer.new_candidate(user, job).deliver_later
      ModelMailer.successfully_inscribed(user, job).deliver_later
      DiscordService.new.inscription_alert_webhook(user, job, added_by_company)
      redirect_to_response(t('inscriptions.messages.inscription_created'), route ? route : job)
    else
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end
end
