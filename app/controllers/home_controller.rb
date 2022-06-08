# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @jobs = Job.active.order('created_at DESC').take(5);
    @jobs_count = Job.active.take(5).count
  end

  def robots
    respond_to :text
  end
end
