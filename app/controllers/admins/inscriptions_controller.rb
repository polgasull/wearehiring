# frozen_string_literal: true

module Admins
  class InscriptionsController < Admins::AdminsController
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
      assign_inscription_to_job(@job, @candidate, admins_job_path(@job.id), params[:inscription][:added_by_company])
    end

    def update
      @inscription = @job.inscriptions.find(params[:id])

      respond_to do |format|
        if @inscription.update(inscription_params)
          if params[:inscription][:status].present?
            # ModelMailer.update_inscription_status(@inscription, @job).deliver_later
            # DiscordService.new.inscription_status_alert_webhook(@inscription, @job)
          end
          format.json { respond_with_bip(@inscription) }
          format.js
        else
          format.json { respond_with_bip(@inscription) }
        end
      end
    end

    def show
      @inscription = @job.inscriptions.find(params[:id])
      return redirect_to_response(t('not_found'), @job, false) unless @inscription
      @user = @inscription.user  
      @inscriptions = @job.inscriptions.where.not(user_id: @user.id).order('created_at DESC').take(10)
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
