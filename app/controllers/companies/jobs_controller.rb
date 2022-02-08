# frozen_string_literal: true

module Companies
  class JobsController < Companies::CompaniesController
    include PaymentHelper
    
    before_action :set_job, only: [:show, :edit, :update]

    COMPANY_PRICE = 10000
  
    def index
      @jobs = current_user.jobs.filter(params).order('created_at DESC')
      @jobs_active_count = @jobs.active.count
      @jobs_expired_count = @jobs.inactive.count
      @jobs_count = @jobs.count
      @total_inscriptions = current_user.total_inscriptions_sum(@jobs)
    end

    def new
      @job_last = current_user.jobs.last
      @job = current_user.jobs.build
      @coupon_names = Coupon.select(:name).map(&:name)
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

      if current_user.jobs.first(3).count == 3
        coupon = Coupon.find_by_name(@job.discount_code)
        discount = coupon.present? ? coupon.value : 0
        price = COMPANY_PRICE
        stripe_process(price, discount)
      end
  
      if @job.save
        TwitterService.new.send_tweet @job
        DiscordService.new.job_alert_webhook @job
        ModelMailer.new_job(current_user, @job).deliver_later
        redirect_to_response(t('jobs.messages.job_created'), thanks_jobs_path) 
      else 
        redirect_back_response(t('jobs.messages.job_not_created'), false)
      end

      rescue Stripe::CardError => e
        flash.alert = e.message
        render action: :new
    end

    def show
      return redirect_to_response(t('not_found'), root_path, false) unless @job
      @inscriptions_count = @job.inscriptions.count
      @matching_candidates = @job.show_matching_candidates(@job.skills)  
  
      @discardeds_count = @job.inscriptions.where(status: [0]).count
      @in_process_count = @job.inscriptions.where(status: [1]).count
      @finalists_count = @job.inscriptions.where(status: [2]).count
      @inscriptions = @job.inscriptions.order(status: :desc)
  
      respond_to do |format|
        format.html
        format.xlsx
      end
    end 
  
    def update
      @job&.update(job_params) ? redirect_to_response(t('jobs.messages.job_updated'), companies_job_path(@job)) : redirect_back_response(t('jobs.messages.job_not_updated'), false)
    end

    private

    def set_job
      @job = current_user.jobs.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to not_found_url
    end

    def job_params
      params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, 
        :remote_ok, :apply_url, :avatar, :salary_from, :salary_to, :open, :tag_list, :expiry_date, 
        :discount_code, :category_id, :job_type_id, :level_id, skill_ids: [])
    end
  end
end
