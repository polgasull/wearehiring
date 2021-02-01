# frozen_string_literal: true

module Candidates
  class InscriptionsController < Candidates::CandidatesController
    include InscriptionsHelper
    before_action :set_job, only: [:create]
    before_action :set_current_user

    # CANDIDATE: SHOW MY INSCRIPTIONS
    def index
      @inscribeds = current_user.inscriptions.where(status: [nil])
      @discardeds = current_user.inscriptions.where(status: [0])
      @in_process = current_user.inscriptions.where(status: [1])
      @finalists = current_user.inscriptions.where(status: [2])
      @inscriptions_count = current_user.inscriptions.count
    end

    def create
      create_inscription(@job, @user)
    end

    private

    def set_current_user
      @user = current_user
      return redirect_back_response(t('devise.failure.unauthenticated'), false) unless @user
    end

    def set_job
      @job = Job.friendly.find(params[:job_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to controller: :errors, action: :not_found
    end
  end
end