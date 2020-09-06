# frozen_string_literal: true

module Admins
  class SettingsController < Admins::AdminsController

    def index
      @categories = Category.all.order("id ASC")
    end

  end
end