# frozen_string_literal: true

module Administrators
  class AdministratorsController < ApplicationController
    include Rescuers::StandardErrorHandler

    before_action :authenticate_user!
    before_action :validate_is_administrator!

    def index
      render body: nil
    end

    private

    def validate_is_administrator!
      return redirect_to root_path unless current_user.is_admin?
    end
  end
end