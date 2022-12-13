# frozen_string_literal: true

module Companies
  class JobsController < Companies::CompaniesController
    include PaymentHelper
    
    before_action :set_job, only: [:show, :edit, :update, :edit_price, :update_price]
    before_action :check_free_jobs_limit, only: [:free]
  
    def index
      @jobs = current_user.jobs.filter_by(params).order('created_at DESC')
      @jobs_active_count = @jobs.active.count
      @jobs_expired_count = @jobs.inactive.count
      @jobs_count = @jobs.count
      @total_inscriptions = current_user.total_inscriptions_sum(@jobs)
    end

    def new_job_index; end

    def new
      @job_last = current_user.jobs.last
      @job = current_user.jobs.build
      @coupon_names = Coupon.select(:name).map(&:name)
    end

    def free
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

      unless @job.is_free_price?
        coupon = Coupon.find_by_name(@job.discount_code)
        discount = (coupon.present? && @job.is_pro_price?) ? coupon.value : 0
        stripe_process(@job.job_price.value, discount)
      end
  
      if @job.save
        send_notifications(current_user, @job)
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
      if params[:search_users]
        @matching_candidates = @job.show_filtered_matching_candidates(@job.skills, params[:search_users])
        respond_to do |format|
          format.js { render partial: 'jobs/shared/we_match_search_results'}
        end
      else 
        @matching_candidates = @job.show_matching_candidates(@job.skills)
      end
      
      @discardeds_count = @job.inscriptions.where(status: [0]).count
      @in_process_count = @job.inscriptions.where(status: [1]).count
      @finalists_count = @job.inscriptions.where(status: [2]).count
      @inscriptions_country_codes = inscriptions_country_code(@job)
      @inscriptions = inscriptions_list(@job)
      @inscriptions_count = @job.inscriptions.where(added_by_company: false).count
      @we_match_inscriptions = @job.inscriptions.where(added_by_company: true).order(status: :desc)
      @we_match_inscriptions_count = @we_match_inscriptions.count
  
      respond_to do |format|
        format.js
        format.html
        format.xlsx
      end
    end

    def update
      @job&.update(job_params) ? redirect_to_response(t('jobs.messages.job_updated'), companies_job_path(@job)) : redirect_back_response(t('jobs.messages.job_not_updated'), false)
    end

    def edit_price
      @coupon_names = Coupon.select(:name).map(&:name)
    end

    def update_price
      coupon = Coupon.find_by_name(params[:job][:discount_code])
      discount = coupon.present? ? coupon.value : 0
      job_price = JobPrice.find(params[:job][:job_price_id]).value
      stripe_process(job_price, discount)

      if @job.update(job_params)
        DiscordService.new.job_upgrade_alert_webhook @job
        redirect_to_response(t('jobs.messages.job_updated'), companies_job_path(@job)) 
      else
        redirect_back_response(t('jobs.messages.job_not_updated'), false)
      end

      rescue Stripe::CardError => e
        flash.alert = e.message
        render action: :edit_price
    end

    private

    def send_notifications(user, job)
      DiscordService.new.job_alert_webhook job
      TwitterService.new.send_tweet job
      TwitterService.new.send_job_detail_tweet @job
      ModelMailer.new_job(user, job).deliver_later
    end

    def inscriptions_list(job)
      if job.is_free_price?
        job.inscriptions.where(added_by_company: false).first(15)
      else
        job.inscriptions.where(added_by_company: false).filter_by(params).order(status: :desc)
      end
    end

    def inscriptions_country_code(job)
      inscriptions = job.inscriptions
      user_country_codes = []
  
      inscriptions.each do |inscription|
        user_country_codes << inscription.user.resident_country_code
      end
  
      user_country_codes.compact.uniq
    end

    def set_job
      @job = current_user.jobs.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to not_found_url
    end

    def check_free_jobs_limit
      if current_user.free_jobs_active.count >= 5
        redirect_back_response(t('jobs.messages.free_jobs_limit'), false)
      end
    end

    def job_params
      params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, 
        :remote_ok, :apply_url, :avatar, :salary_from, :salary_to, :open, :tag_list, :expiry_date, 
        :discount_code, :category_id, :job_type_id, :level_id, :job_price_id, skill_ids: [])
    end
  end
end
