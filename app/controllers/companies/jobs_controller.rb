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

    def new_job_index
      redirect_to new_companies_job_path
    end

    def new
      @job_last = current_user.jobs.last
      @job = current_user.jobs.build
      @coupon_names = Coupon.select(:name).map(&:name)
      @is_first_job = current_user.jobs.empty? || current_user.jobs.first.id.blank?
    end

    def free
      redirect_to new_companies_job_path
    end

    def edit
      @job_last = current_user.jobs.last
      return redirect_back_response(t('jobs.messages.unauthorized_to_edit'), false) if @job.is_free_price?
    end
  
    def create
      job_last = current_user.jobs.last
      @job = current_user.jobs.build(job_params)
  
      @job.reference = "wah#{DateTime.now.year}#{SecureRandom.hex(3)}"
      @job.expiry_date = DateTime.now() + 60.days
      @job.job_price_id = JobPrice.find_by(internal_name: 'pro').id
      @job.open = false
  
      if params[:job][:avatar].nil? && job_last
        @job.avatar = job_last.avatar
      end
  
      if @job.save
        if current_user.jobs.count == 1
          @job.update!(open: true)
          send_notifications(current_user, @job)
          redirect_to companies_job_thanks_path(@job)
        else
          redirect_to stripe_checkout_companies_job_url(@job)
        end
      else
        render :new
      end
    end

    def show
      return redirect_to_response(t('not_found'), root_path, false) unless @job
      if params[:search_users]
        @matching_candidates ||= @job.show_filtered_matching_candidates(@job.skills, params[:search_users])
        respond_to do |format|
          format.js { render partial: 'jobs/shared/we_match_search_results'}
        end
      else 
        @matching_candidates ||= @job.show_matching_candidates(@job.skills)
      end
      
      @discardeds_count ||= @job.inscriptions.where(status: [0]).count
      @in_process_count ||= @job.inscriptions.where(status: [1]).count
      @finalists_count ||= @job.inscriptions.where(status: [2]).count
      @inscriptions_country_codes ||= inscriptions_country_code(@job)
      @inscriptions ||= inscriptions_list(@job)
      @inscriptions_count ||= @inscriptions.count
      @we_match_inscriptions_count ||= @job.inscriptions.where(added_by_company: true).count
  
      respond_to do |format|
        format.js
        format.html
        format.xlsx
      end
    end

    def update
      return redirect_back_response(t('jobs.messages.job_not_updated'), false) if @job.is_free_price?
      
      if @job.update(job_params)
        redirect_to_response(t('jobs.messages.job_updated'), companies_job_path(@job))
      else
        redirect_back_response(t('jobs.messages.job_not_updated'), false)
      end
    end

    def edit_price
      redirect_to edit_companies_job_path
    end

    def stripe_checkout
      @job = current_user.jobs.find(params[:id])
    
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price: ENV['STRIPE_PRICE_ID'],
          quantity: 1,
          tax_rates: [ENV['STRIPE_TAX_ID']],
        }],
        mode: 'payment',
        success_url: success_companies_jobs_url(@job),
        cancel_url: cancel_companies_jobs_url,
        locale: I18n.locale.to_s,
        allow_promotion_codes: true,
        billing_address_collection: :required
      )
    
      redirect_to session.url
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

    def success(job)
      job.update!(open: true)
      # Retrieve and update the job based on the Stripe session or payment intent
      # Handle any post-payment success logic here
      send_notifications(current_user, job)
      redirect_to companies_job_thanks_path(job)
    end
    
    def cancel
      # Handle any post-payment cancellation logic here
      flash[:alert] = t('payment_canceled')
      redirect_to new_companies_job_path
    end

    def thanks
      redirect_to root_path unless current_user.jobs.any?

      job = current_user.jobs.find(params[:job_id])

      if job.present?
        @job = job
      else 
        @job = current_user.jobs.last
      end
    end

    private

    def send_notifications(user, job)
      DiscordService.new.job_alert_webhook job
      TwitterService.new.send_tweet job
      ModelMailer.new_job(user, job).deliver_later
    end

    def inscriptions_list(job)
      if job.is_free_price?
        job.inscriptions.first(15)
      else
        job.inscriptions.filter_by(params).order(status: :desc)
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
