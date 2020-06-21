class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :validate_is_company!, only: [:jobs]
  before_action :validate_is_candidate!, only: [:inscriptions]

  def jobs
    @jobs = @user.jobs.filter(params).order('created_at DESC')
    @jobs_active_count = @jobs.not_expired.count
    @jobs_expired_count = @jobs.expired.count
    @jobs_count = @jobs.count
  end

  def inscriptions
    @inscriptions = @user.inscriptions
    @inscriptions_count = @user.inscriptions.count
  end

  def update
    @user.update(user_params) ? redirect_to_response(t('users.messages.user_updated'), edit_user_registration_path) : redirect_back_response(t('users.messages.user_not_updated'), false)
  end

  private

  def set_user
    @user = current_user
    return redirect_back_response(t('devise.failure.unauthenticated'), false) unless @user
  end

  def user_params
    params.require(:user).permit(:phone, :profile_url, :current_position)
  end
end
