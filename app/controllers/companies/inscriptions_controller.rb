# frozen_string_literal: true

module Companies
  class InscriptionsController < Companies::CompaniesController
    before_action :set_job

    def index
      return redirect_to_response(t('not_found'), root_path, false) unless @job
  
      @inscribeds = @job.inscriptions.where(status: [nil, 0])
      @in_process = @job.inscriptions.where(status: [1])
      @finalists = @job.inscriptions.where(status: [2])
      @inscriptions = @job.inscriptions
      @inscriptions_count = @job.inscriptions.count
  
      respond_to do |format|
        format.html
        format.xlsx
      end
    end
  
    def update
      @inscription = @job.inscriptions.find(params[:id])
      @inscription.update(inscription_params) ? 
        redirect_back_response(t('users.messages.user_updated')) : 
        redirect_back_response(t('users.messages.user_not_updated'), false)
    end
  
    def show
      @inscription = @job.inscriptions.find(params[:id])
      return redirect_to_response(t('not_found'), @job, false) unless @inscription
      @user = @inscription.user
    end
  
    private
  
    def set_job
      @job = current_user.jobs.find(params[:job_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to not_found_url
    end

    def inscription_params
      params.require(:inscription).permit(:job_id, :user_id, :status)
    end
  end
end