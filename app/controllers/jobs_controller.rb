class JobsController < ApplicationController
  include PaymentHelper
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update]
  before_action :validate_is_job_owner, only: [:edit, :update]
  before_action :validate_is_company_ambassador_or_admin!, except: [:index, :show, :thanks]
  before_action :validate_is_expired!, only: [:show]

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
    
    if !current_user.is_ambassador? && !current_user.jobs.first.id.blank?
      stripe_process
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

  def thanks
    if current_user.jobs.any?
      @job = current_user.jobs.last
    else 
      redirect_to root_path
    end
  end

  private

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
      :category_id, :job_type_id, :level_id)
  end

  def validate_is_expired!
    if !@job.open? && !@job.user_owner_or_admin(current_user)
      return redirect_to_response(t('jobs.messages.job_expired'), root_path, false) 
    end
  end

  # def slack_ping_channel_message
  #   job_link = "[Puedes aplicar aquí ¡Mucha suerte!](https://www.wearehiring.io/ofertas-empleo-digital/#{@job.slug})"
  #   new_job_message = "Nuevo Job! #{@job.title} en #{@job.job_author} en #{@job.location} #{'(Remoto)' if @job.remote_ok?} 
  #     #{Slack::Notifier::Util::LinkFormatter.format(job_link)}"
  #   SlackService.new.ping_channel_message new_job_message, "jobs_#{@job.category.internal_name}"
  # end
end
