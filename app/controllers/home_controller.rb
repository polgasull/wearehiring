class HomeController < ApplicationController
  def index
    @jobs = Job.active.order('created_at DESC').take(10);
    @jobs_count = Job.active.take(10).count
    candidate_variables(current_user) if current_user&.is_candidate?
    company_variables(current_user) if current_user&.is_company? || current_user&.is_ambassador?
  end

  def robots
    @inactive_jobs = Job.inactive.order('created_at DESC')
    respond_to :text
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
    @discardeds_count = user.inscriptions.where(status: [0]).count
    @in_process_count = user.inscriptions.where(status: [1]).count
    @finalists_count = user.inscriptions.where(status: [2]).count
  end
end
