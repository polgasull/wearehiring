class JobsController < ApplicationController
  include PaymentHelper
  before_action :must_signin_as_company, only: [:new]
  before_action :authenticate_user!, except: [:index, :show, :new]
  before_action :set_job, only: [:show, :edit, :update]
  before_action :validate_is_job_owner, only: [:edit, :update]
  before_action :validate_is_recruiter!, except: [:index, :show]
  before_action :validate_is_expired!, only: [:show]
  before_action :set_candidate, only: [:create_inscription]

  AMBASSADOR_PRICE = 5586
  COMPANY_PRICE = 11286

  def index
    if params[:sort_by]
      @jobs = Job.active.order_list(params[:sort_by]).page(params[:page]).per(10)
      @jobs_count = Job.active.count
    else 
      @jobs = Job.active.order('created_at DESC').filter(params).page(params[:page]).per(10)
      @jobs_count = Job.active.filter(params).count
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    return redirect_to_response(t('not_found'), root_path, false) unless @job
    @inscriptions_count = @job.inscriptions.count
    @same_category_jobs = Job.active.same_category(@job).order('created_at DESC').take(3)
    @matching_candidates = @job.show_matching_candidates(@job.skills)
  end

  def new
    @job_last = current_user.jobs.last
    @job = current_user.jobs.build
  end

  def edit
  end

  def create
    job_last = current_user.jobs.last
    @job = current_user.jobs.build(job_params)

    @job.reference = "wah#{DateTime.now.year}#{SecureRandom.hex(3)}"
    @job.expiry_date = DateTime.now() + 60.days

    if params[:job][:avatar].nil? && job_last
      @job.avatar = job_last.avatar
    end
    
    if !current_user.jobs.first.id.blank?
      price = current_user.is_ambassador? ? AMBASSADOR_PRICE : COMPANY_PRICE
      stripe_process(price)
    end

    if @job.save
      TwitterService.new.send_tweet @job
      ModelMailer.new_job(current_user, @job).deliver
      redirect_to_response(t('jobs.messages.job_created'), thanks_job_page_path) 
    else 
      redirect_back_response(t('jobs.messages.job_not_created'), false)
    end

    rescue Stripe::CardError => e
      flash.alert = e.message
      render action: :new
  end

  def update
    @job&.update(job_params) ? redirect_to_response(t('jobs.messages.job_updated'), @job) : redirect_back_response(t('jobs.messages.job_not_updated'), false)
  end

  def create_inscription
    @job = current_user.jobs.friendly.find(params[:job_id])
    return redirect_back_response(t('already_inscribed'), false) if @candidate.is_already_inscribed(@job)

    @inscription = @job.inscriptions.build(job_id: @job.id, user_id: @candidate.id)
    
    if @inscription.save  
      ModelMailer.new_candidate(@candidate, @job).deliver if Rails.env.production?
      ModelMailer.successfully_inscribed(@candidate, @job).deliver if Rails.env.production?
      redirect_to_response(t('inscriptions.messages.inscription_created'), @inscription.job)
    else 
      redirect_back_response(t('inscriptions.messages.inscription_not_created'), false)
    end
  end

  def thanks
    if current_user.jobs.any?
      @job = current_user.jobs.last
    else 
      redirect_to root_path
    end
  end

  private

  def must_signin_as_company
    return redirect_to_response(t('devise.failure.unauthenticated'), new_user_session_path(:company => "true"), false) unless user_signed_in?
  end

  def set_job
    @job = Job.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to controller: :errors, action: :not_found
  end

  def validate_is_job_owner
    return redirect_to_response(t('not_found'), root_path, false) unless @job.user_id == current_user.id
  end

  def job_params
    params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, 
      :remote_ok, :apply_url, :avatar, :salary_from, :salary_to, :open, :tag_list, :expiry_date, 
      :category_id, :job_type_id, :level_id, skill_ids: [])
  end

  def validate_is_expired!
    if !@job.open? && !@job.user_owner_or_admin(current_user)
      return redirect_to_response(t('jobs.messages.job_expired'), root_path, false) 
    end
  end

  def set_candidate
    @candidate = User.where(user_type: 1).find(params[:user_id])
  end

  # def slack_ping_channel_message
  #   job_link = "[Puedes aplicar aquí ¡Mucha suerte!](https://www.wearehiring.io/ofertas-empleo-digital/#{@job.slug})"
  #   new_job_message = "Nuevo Job! #{@job.title} en #{@job.job_author} en #{@job.location} #{'(Remoto)' if @job.remote_ok?} 
  #     #{Slack::Notifier::Util::LinkFormatter.format(job_link)}"
  #   SlackService.new.ping_channel_message new_job_message, "jobs_#{@job.category.internal_name}"
  # end
end
