# frozen_string_literal: true

module Companies
  class DashboardsController < Companies::CompaniesController

    def index
      @jobs = Job.active.order('created_at DESC').take(10);
      @jobs_count = Job.active.take(10).count
      @company_jobs = user.jobs.all.order('created_at DESC')
      @company_jobs_count = user.jobs.all.count
      @company_jobs_open_count = user.jobs.where(open: true).count
      @company_jobs_close_count = user.jobs.where(open: false).count
      @total_inscriptions = user.total_inscriptions_sum(user.jobs.all)
      @last_inscribeds = user.last_inscribeds(user.jobs.all.order('created_at DESC')).take(15)
    end

  end
end
