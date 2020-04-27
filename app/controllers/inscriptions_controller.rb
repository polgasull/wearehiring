class InscriptionsController < ApplicationController
  before_action :set_job, only: [:create, :show]
  before_action :authenticate_user!
  before_action :validate_is_candidate!, except: [:show]

  def create

    return redirect_back_response(t('already_inscribed'), false) if current_user.is_already_inscribed(@job)

    @inscription = @job.inscriptions.build(inscription_params)
    if @inscription.save  
      ModelMailer.new_candidate(current_user, @job).deliver
      ModelMailer.new_inscription(current_user, @job).deliver
      redirect_to_response(t('inscriptions.messages.inscription_created'), @inscription.job)
    else 
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end

  def show
    return redirect_to_response(t('access_forbidden'), root_path, false) unless @job.user_creator(current_user.id)

    @inscriptions = @job.inscriptions
    @inscriptions_count = @job.inscriptions.count
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def inscription_params
    params.require(:inscription).permit(:job_id, :user_id)
  end
end