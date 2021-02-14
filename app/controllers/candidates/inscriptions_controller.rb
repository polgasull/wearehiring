# frozen_string_literal: true

module Candidates
  class InscriptionsController < Candidates::CandidatesController
    include InscriptionsHelper
    before_action :set_job, only: [:create]

    # CANDIDATE: SHOW MY INSCRIPTIONS
    def index
      @inscribeds = current_user.inscriptions.where(status: [nil])
      @discardeds = current_user.inscriptions.where(status: [0])
      @in_process = current_user.inscriptions.where(status: [1])
      @finalists = current_user.inscriptions.where(status: [2])
      @inscriptions_count = current_user.inscriptions.count
    end

    def create
      assign_inscription_to_job(@job, current_user)
    end

    private

    def set_job
      @job = Job.find(params[:job_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to not_found_url
    end
  end
end