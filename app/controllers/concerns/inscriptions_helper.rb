# frozen_string_literal: true

module InscriptionsHelper

  def assign_inscription_to_job(job, user, route)
    return redirect_back_response(t('already_inscribed'), false) if user.is_already_inscribed(job)
      
    @inscription = job.inscriptions.build(job_id: job.id, user_id: user.id)
    
    if @inscription.save  
      ModelMailer.new_candidate(user, job).deliver_later if Rails.env.production? 
      ModelMailer.successfully_inscribed(user, job).deliver_later if Rails.env.production? 
      redirect_to_response(t('inscriptions.messages.inscription_created'), route ? route : job)
    else 
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end
end