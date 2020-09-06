# frozen_string_literal: true

module Admins
  class SettingsController < Admins::AdminsController

    def index
      @categories = Category.all.order("id ASC")
      @job_types = JobType.all.order("id ASC")
      @levels = Level.all.order("id ASC")
    end

  end
end