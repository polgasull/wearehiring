class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:candidate_access]
  before_action :set_current_user, except: [:candidate_access]
  before_action :validate_is_company_or_ambassador!, only: [:jobs]
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
    if @user.update(user_params)
      SendgridService.new.update_contact @user
      redirect_to_response(t('users.messages.user_updated'), edit_user_registration_path)
    else 
      redirect_back_response(t('users.messages.user_not_updated'), false)
    end
  end

  def candidate_access;end

  private

  def set_current_user
    @user = current_user
    return redirect_back_response(t('devise.failure.unauthenticated'), false) unless @user
  end

  def user_params
    params.require(:user).permit(:name, :last_name, :phone, :profile_url, :current_position, 
    :picture_url, :description, :github, :pinterest, :behance, :personal_website)
  end
end
