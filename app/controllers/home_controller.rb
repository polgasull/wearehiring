class HomeController < ApplicationController
  def index
    @jobs = Job.active.order('created_at DESC').take(10);
    @jobs_count = Job.active.take(10).count
    if current_user&.is_candidate?
      @candidate_inscriptions = current_user.inscriptions.all
    end
    if current_user&.is_company?
      @company_jobs = current_user.jobs.all
    end
  end

  def robots
    @inactive_jobs = Job.inactive.order('created_at DESC')
    respond_to :text
  end
end
