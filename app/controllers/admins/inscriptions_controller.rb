# frozen_string_literal: true

module Admins
  class InscriptionsController < Admins::AdminsController
    include InscriptionsHelper

    before_action :set_job
    before_action :set_candidate, only: [:create]

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

    def create
      assign_inscription_to_job(@job, @candidate, admins_job_path(@job.id))
    end

    def update
      @inscription = @job.inscriptions.find(params[:id])

      respond_to do |format|
        if @inscription.update(inscription_params)
          ModelMailer.update_inscription_status(@inscription, @job).deliver_later
          format.html { redirect_to_response(t('users.messages.user_not_updated'), admins_job_path(@job)) }
          format.json { respond_with_bip(@inscription) }
        else
          format.html { redirect_to_response(t('users.messages.user_not_updated'), admins_job_path(@job), false)  }
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
      @job = Job.find_by_id(params[:job_id])
    end

    def inscription_params
      params.require(:inscription).permit!
    end
  end
end