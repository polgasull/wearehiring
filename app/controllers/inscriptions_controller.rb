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
      @inscription.user.update(accepted_terms: true) unless @inscription.user.accepted_terms
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

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"inscriptions-list.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  private

  def set_job
    @job = Job.friendly.find(params[:job_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to controller: :errors, action: :not_found
  end

  def set_current_user_job
    @job = current_user.jobs.friendly.find(params[:job_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to controller: :errors, action: :not_found
  end

  def inscription_params
    params.require(:inscription).permit(:job_id, :user_id)
  end
end