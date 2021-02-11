# frozen_string_literal: true

module Candidates
  class CandidatesController < ApplicationController
    before_action :authenticate_user!
    before_action :validate_is_candidate!

    def index
      render body: nil
    end
  end
end