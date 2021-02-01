# frozen_string_literal: true

module Companies
  class JobsController < Companies::CompaniesController
    before_action :set_current_user

    def index
      @jobs = @user.jobs.filter(params).order('created_at DESC')
      @jobs_active_count = @jobs.active.count
      @jobs_expired_count = @jobs.inactive.count
      @jobs_count = @jobs.count
    end

    private

    def set_current_user
      @user = current_user
      return redirect_back_response(t('devise.failure.unauthenticated'), false) unless @user
    end
  end
end
