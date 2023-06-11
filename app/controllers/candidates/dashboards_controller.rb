# frozen_string_literal: true

module Candidates
  class DashboardsController < Candidates::CandidatesController

    def index
      @candidate_inscriptions = current_user.inscriptions.all.order('created_at DESC')
      @in_process_count = current_user.inscriptions.where(status: [1]).count
      @finalists_count = current_user.inscriptions.where(status: [2]).count
    end

  end
end
