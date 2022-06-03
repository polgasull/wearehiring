# frozen_string_literal: true

module Companies
  class CompaniesController < ApplicationController
    before_action :authenticate_user!
    before_action :validate_is_company!

    def index
      render body: nil
    end
  end
end
