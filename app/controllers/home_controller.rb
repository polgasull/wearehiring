class HomeController < ApplicationController
  def index
    @jobs = Job.active.order('created_at DESC').take(10);
    @jobs_count = Job.active.take(10).count
  end

  def robots
    @inactive_jobs = Job.inactive.order('created_at DESC')
    respond_to :text
  end
end
