class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = Job.active.order('created_at DESC').take(10);
    @jobs_count = Job.active.take(10).count
    candidate_variables(current_user)
    company_variables(current_user) 
  end

  private 

  def company_variables(user)
    @company_jobs = user.jobs.all
    @company_jobs_count = user.jobs.all.count
    @company_jobs_open_count = user.jobs.where(open: true).count
    @company_jobs_close_count = user.jobs.where(open: false).count
    @total_inscriptions = user.total_inscriptions_sum(user.jobs.all)
    @last_inscribeds = user.last_inscribeds(user.jobs.all).take(15)
  end

  def candidate_variables(user)
    @candidate_inscriptions = user.inscriptions.all
    @in_process_count = user.inscriptions.where(status: [1]).count
    @finalists_count = user.inscriptions.where(status: [2]).count
  end
end