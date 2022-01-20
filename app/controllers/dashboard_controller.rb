class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = Job.active.order('created_at DESC').take(10);
    @jobs_count = Job.active.take(10).count
    candidate_variables(current_user) if current_user.is_candidate?
    company_variables(current_user) if current_user.is_company? || current_user.is_ambassador? 
    admin_variables if current_user.is_admin?
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

  def admin_variables
    @candidates_by_date = User.where(user_type: 1).group_by_day(:created_at, last: 20, reverse: true).count
    @candidates_by_week = User.where(user_type: 1).group_by_week(:created_at, last: 20, reverse: true).count
    @candidates_by_month = User.where(user_type: 1).group_by_month(:created_at, format: "%b %Y", last: 20, reverse: true).count
    @companies_by_date = User.where(user_type: 2).group_by_day(:created_at, last: 20, reverse: true).count
    @companies_by_week = User.where(user_type: 2).group_by_week(:created_at, last: 20, reverse: true).count
    @companies_by_month = User.where(user_type: 2).group_by_month(:created_at, format: "%b %Y", last: 20, reverse: true).count
    @jobs_by_date = Job.all.group_by_day(:created_at, last: 20, reverse: true).count
    @jobs_by_week = Job.all.group_by_week(:created_at, last: 20, reverse: true).count
    @jobs_by_month = Job.all.group_by_month(:created_at, format: "%b %Y", last: 20, reverse: true).count
  end
end