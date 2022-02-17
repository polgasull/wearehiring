# frozen_string_literal: true

module Admins
  class AdminsController < ApplicationController
    before_action :authenticate_user!
    before_action :validate_is_admin!

    def index
      render body: nil
    end
  end
end
