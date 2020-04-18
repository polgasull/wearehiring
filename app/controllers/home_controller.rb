class HomeController < ApplicationController
  def index
    @jobs = Job.not_expired.order('created_at DESC').take(10);
    @jobs_count = Job.not_expired.count
  end
end
