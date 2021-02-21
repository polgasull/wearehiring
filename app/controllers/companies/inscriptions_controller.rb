# frozen_string_literal: true

module Companies
  class InscriptionsController < Companies::CompaniesController
    before_action :set_job

    def index
      return redirect_to_response(t('not_found'), root_path, false) unless @job
  
      @inscribeds_count = @job.inscriptions.where(status: [nil]).count
      @discardeds_count = @job.inscriptions.where(status: [0]).count
      @in_process_count = @job.inscriptions.where(status: [1]).count
      @finalists_count = @job.inscriptions.where(status: [2]).count
      @inscriptions = @job.inscriptions
      @inscriptions_count = @job.inscriptions.count
  
      respond_to do |format|
        format.html
        format.xlsx
      end
    end
  
    def update
      @inscription = @job.inscriptions.find(params[:id])

      respond_to do |format|
        if @inscription.update(inscription_params)
          format.html { redirect_to_responset(t('users.messages.user_not_updated'), companies_job_inscriptions_path(@job)) }
          format.json { respond_with_bip(@inscription) }
        else
          format.html { redirect_to_response(t('users.messages.user_not_updated'), companies_job_inscriptions_path(@job), false)  }
          format.json { respond_with_bip(@inscription) }
        end
      end
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