# frozen_string_literal: true

module InscriptionsHelper

  def create_inscription(job, user)
    return redirect_back_response(t('already_inscribed'), false) if user.is_already_inscribed(job)
      
    @inscription = job.inscriptions.build(job_id: job.id, user_id: user.id)
    
    if @inscription.save  
      ModelMailer.new_candidate(user, job).deliver if Rails.env.production?
      ModelMailer.successfully_inscribed(user, job).deliver if Rails.env.production?
      redirect_to_response(t('inscriptions.messages.inscription_created'), @inscription.job)
    else 
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end
end