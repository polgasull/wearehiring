# frozen_string_literal: true

module Candidates
  class DashboardsController < Admins::AdminsController

    def index
      @jobs = Job.active.order('created_at DESC').take(10);
      @jobs_count = Job.active.take(10).count
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
end
