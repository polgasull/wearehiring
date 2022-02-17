# frozen_string_literal: true

module Admins
  class SettingsController < Admins::AdminsController

    def index
      @categories = Category.all.order("id ASC")
      @job_types = JobType.all.order("id ASC")
      @levels = Level.all.order("id ASC")
      @skills = Skill.all.order("id ASC")
      @coupons = Coupon.all.order("id ASC")
      @partners = Partner.all.order("id ASC")
    end

  end
end
