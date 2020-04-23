class InscriptionsController < ApplicationController
  before_action :set_job, only: [:create]
  before_action :authenticate_user!
  before_action :validate_is_candidate!

  def create

    return redirect_back_response(t('already_inscribed'), false) if current_user.is_already_inscribed(@job)

    @inscription = @job.inscriptions.build(inscription_params)
    if @inscription.save  
      ModelMailer.new_inscription(current_user, @job).deliver
      redirect_to_response(t('inscriptions.messages.inscription_created'), @inscription.job)
    else 
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end

  def user_inscriptions
    @inscriptions = current_user.my_inscriptions
    @inscriptions_count = current_user.inscriptions.count
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def inscription_params
    params.require(:inscription).permit(:job_id, :user_id)
  end
end