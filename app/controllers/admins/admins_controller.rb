# frozen_string_literal: true

module Admins
  class AdminsController < ApplicationController

    before_action :authenticate_user!
    before_action :validate_is_admin!

    def index
      render body: nil
    end

    private

    def validate_is_admin!
      return redirect_to root_path unless current_user.is_admin?
    end
  end
end