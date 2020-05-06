class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :validate_is_company!, only: [:jobs]
  before_action :validate_is_candidate!, only: [:inscriptions]

  def jobs
    return redirect_back_response(t('not_found'), false) unless @user == current_user
    @jobs = @user.jobs.filter(params).order('created_at DESC')
    @jobs_active_count = @jobs.not_expired.count
    @jobs_expired_count = @jobs.expired.count
    @jobs_count = @jobs.count
  end

  def inscriptions
    return redirect_back_response(t('not_found'), false) unless @user == current_user
    @inscriptions = @user.inscriptions
    @inscriptions_count = @user.inscriptions.count
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
    return redirect_back_response(t('devise.failure.unauthenticated'), false) unless @user
  end

end
