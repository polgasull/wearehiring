class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update]
  before_action :validate_is_job_owner, only: [:edit, :update]
  before_action :validate_is_company_or_admin!, except: [:index, :show]
  before_action :validate_is_expired!, only: [:show]

  def index
    if params[:sort_by]
      @jobs = Job.not_expired.order_list(params[:sort_by]).page(params[:page]).per(25)
      @jobs_count = Job.not_expired.count
    else 
      @jobs = Job.not_expired.filter(params).order('created_at DESC').page(params[:page]).per(25)
      @jobs_count = Job.not_expired.filter(params).count
    end
  end

  def show
    return redirect_to_response(t('not_found'), root_path, false) unless @job
    @inscriptions_count = @job.inscriptions.count
  end

  def new
    @job = current_user.jobs.build
  end

  def edit
  end

  def create
    @job = current_user.jobs.build(job_params)

    @job.reference = "wah#{DateTime.now.year}#{SecureRandom.hex(3)}"
    @job.expiry_date = DateTime.now() + 30.days

    token = params[:stripeToken]
    job_type = params[:job_type]
    job_title = params[:title]
    card_brand = params[:user][:card_brand]
    card_exp_month = params[:user][:card_exp_month]
    card_exp_year = params[:user][:card_exp_year]
    card_last4 = params[:user][:card_last4]

    charge = Stripe::Charge.create(
      :amount => 11286,
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

    if @job.save
      ModelMailer.new_job(current_user, @job).deliver
      redirect_to_response(t('jobs.messages.job_created'), @job) 
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
    params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, :remote_ok, :apply_url, :avatar, :salary_from, :salary_to, :open, :tag_list, :category_id, :job_type_id, :level_id)
  end

  def validate_is_expired!
    if @job.is_expired? && !@job.user_owner_or_admin(current_user)
      redirect_to_response(t('jobs.messages.job_expired'), root_path, false) 
    end
  end

  def calculate_price(price, iva, irpf)
    percent_iva = iva.to_f / 100.0
    percent_irpf = irpf.to_f / 100.0
    (price - (price * percent_iva)).to_f.round(2)
  end
end
