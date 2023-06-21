# frozen_string_literal: true

module Companies
  class DashboardsController < Companies::CompaniesController

    def index
      @jobs = Job.active.order('created_at DESC').take(10);
      @jobs_count = Job.active.take(10).count
      @company_jobs = current_user.jobs.all.order('created_at DESC')
      @company_jobs_count = current_user.jobs.all.count
      @company_jobs_open_count = current_user.jobs.where(open: true).count
      @company_jobs_close_count = current_user.jobs.where(open: false).count
      @total_inscriptions = current_user.total_inscriptions_sum(current_user.jobs.all)
      @last_inscribeds = current_user.last_inscribeds(current_user.jobs.all.order('created_at DESC')).take(15)
    end

  end
end
