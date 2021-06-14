# frozen_string_literal: true

module Companies
  class InscriptionsController < Companies::CompaniesController
    include InscriptionsHelper

    before_action :set_job
    before_action :set_candidate, only: [:create]

    def index
      return redirect_to_response(t('not_found'), root_path, false) unless @job
  
      @inscriptions = @job.inscriptions
      @inscriptions_count = @job.inscriptions.count
  
      respond_to do |format|
        format.xlsx
      end
    end

    def create
      assign_inscription_to_job(@job, @candidate, companies_job_path(@job.id))
    end
  
    def update
      @inscription = @job.inscriptions.find(params[:id])

      respond_to do |format|
        if @inscription.update(inscription_params)
          ModelMailer.update_inscription_status(current_user, @inscription, @job).deliver_later if Rails.env.staging?
          format.html { redirect_to_responset(t('users.messages.user_not_updated'), companies_job_path(@job)) }
          format.json { respond_with_bip(@inscription) }
        else
          format.html { redirect_to_response(t('users.messages.user_not_updated'), companies_job_path(@job), false)  }
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

    def set_candidate
      @candidate = User.where(user_type: 1).find_by_id(params[:user_id])
    end
  
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