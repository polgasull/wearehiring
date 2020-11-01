class HomeController < ApplicationController
  def index
    @jobs = Job.not_expired.order('created_at DESC').take(10);
    @jobs_count = Job.not_expired.take(10).count
  end

  def robots
    respond_to :text
  end
end
