class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :validate_is_company_or_ambassador!, only: [:jobs]
  before_action :validate_is_candidate!, only: [:inscriptions]

  def jobs
    @jobs = @user.jobs.filter(params).order('created_at DESC')
    @jobs_active_count = @jobs.active.count
    @jobs_expired_count = @jobs.inactive.count
    @jobs_count = @jobs.count
  end

  def inscriptions
    @inscribeds = @user.inscriptions.where(status: [nil])
    @discardeds = @user.inscriptions.where(status: [0])
    @in_process = @user.inscriptions.where(status: [1])
    @finalists = @user.inscriptions.where(status: [2])
    @inscriptions_count = @user.inscriptions.count
  end

  def update
    if @user.update(user_params)
      if params[:job_id]
        @job = Job.find_by_id(params[:job_id])
        create_inscription(@job, @user)
      end
      SendgridService.new.update_contact @user
      return redirect_back_response(t('successfully_updated'))
    else 
      redirect_back_response(t('users.messages.user_not_updated'), false)
    end
  end

  private

  def set_current_user
    @user = current_user
    return redirect_back_response(t('devise.failure.unauthenticated'), false) unless @user
  end

  def user_params
    params.require(:user).permit(:name, :last_name, :phone, :profile_url, :current_position, 
    :picture_url, :description, :github, :pinterest, :behance, :personal_website, skill_ids: [])
  end

  def create_inscription(job, user)
    @inscription = Inscription.create(job_id: job.id, user_id: user.id)
    if @inscription.save
      flash[:notice] = t('inscriptions.messages.inscription_created')
      ModelMailer.new_candidate(user, job).deliver if Rails.env.production?
      ModelMailer.successfully_inscribed(user, job).deliver if Rails.env.production?
    else 
      flash[:alert] = t('already_inscribed')
    end
  end
end
