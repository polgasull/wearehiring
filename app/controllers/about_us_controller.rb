# frozen_string_literal: true

class AboutUsController < ApplicationController

  def about_us
    @jobs = Job.active.order('created_at DESC').take(5);
    @jobs_count = Job.active.take(5).count
  end

end