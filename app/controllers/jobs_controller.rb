class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    if params[:sort_by]
      @jobs = Job.not_expired.order_list(params[:sort_by]).page(params[:page]).per(10)
      @jobs_count = Job.not_expired.count
    else 
      @jobs = Job.not_expired.filter(params).order('created_at DESC').page(params[:page]).per(10)
      @jobs_count = Job.not_expired.filter(params).count
    end
  end

  def user_jobs
    @jobs = current_user.my_jobs.filter(params).order('created_at DESC').page(params[:page]).per(25)
    @jobs_count = current_user.jobs.count
  end

  def show
  end

  def new
    @job = current_user.jobs.build
  end

  def edit
  end

  def create
    @job = current_user.jobs.build(job_params)

    token = params[:stripeToken]
    job_type = params[:job_type]
    job_title = params[:title]
    card_brand = params[:user][:card_brand]
    card_exp_month = params[:user][:card_exp_month]
    card_exp_year = params[:user][:card_exp_year]
    card_last4 = params[:user][:card_last4]

    charge = Stripe::Charge.create(
      :amount => 10000,
      :currency => 'eur',
      :description => job_type,
      :statement_descriptor => job_title,
      :source => token
    )

    current_user.stripe_id = charge.id
    current_user.card_brand = card_brand
    current_user.card_exp_month = card_exp_month
    current_user.card_exp_year = card_exp_year
    current_user.card_last4 = card_last4
    current_user.save!

    @job.save ? redirect_to_response(t('jobs.messages.job_created'), @job) : redirect_back_response(t('jobs.messages.job_not_created'), false)

    rescue Stripe::CardError => e
      flash.alert = e.message
      render action: :new
  end

  def update
    @job.update(job_params) ? redirect_to_response(t('jobs.messages.job_updated'), @job) : redirect_back_response(t('jobs.messages.job_not_updated'), false)
  end

  def destroy
    @job.destroy ? redirect_back_response(t('job_deleted')) : redirect_back_response(t('job_not_deleted'), false)
  end

  private

    def set_job
      @job = Job.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, :remote_ok, :apply_url, :avatar, :budget, :open, :tag_list, :expiry_date, :category_id, :job_type_id)
    end
end
