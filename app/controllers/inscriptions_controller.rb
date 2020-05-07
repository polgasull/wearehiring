class InscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:create]
  before_action :validate_is_candidate!, only: [:create]
  before_action :set_current_user_job, only: [:show]
  before_action :validate_is_company!, only: [:show]

  def create
    return redirect_back_response(t('already_inscribed'), false) if current_user.is_already_inscribed(@job)

    @inscription = @job.inscriptions.build(inscription_params)
    
    if @inscription.save  
      ModelMailer.new_candidate(current_user, @job).deliver unless Rails.env.test?
      ModelMailer.new_inscription(current_user, @job).deliver unless Rails.env.test?
      redirect_to_response(t('inscriptions.messages.inscription_created'), @inscription.job)
    else 
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end

  def show
    return redirect_to_response(t('not_found'), root_path, false) unless @job

    @inscriptions = @job.inscriptions
    @inscriptions_count = @job.inscriptions.count
  end

  private

  def set_job
    @job = Job.find_by_id(params[:job_id])
  end

  def set_current_user_job
    @job = current_user.jobs.find_by_id(params[:id])
  end

  def inscription_params
    params.require(:inscription).permit(:job_id, :user_id)
  end
end