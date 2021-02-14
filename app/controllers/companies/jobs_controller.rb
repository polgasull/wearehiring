# frozen_string_literal: true

module Companies
  class JobsController < Companies::CompaniesController
    include PaymentHelper
    include InscriptionsHelper

    before_action :set_job, only: [:show, :edit, :update]
    before_action :set_candidate, only: [:create_inscription]

    AMBASSADOR_PRICE = 5586
    COMPANY_PRICE = 11286
  
    def index
      @jobs = current_user.jobs.filter(params).order('created_at DESC')
      @jobs_active_count = @jobs.active.count
      @jobs_expired_count = @jobs.inactive.count
      @jobs_count = @jobs.count
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
        redirect_to_response(t('jobs.messages.job_created'), thanks_jobs_path) 
      else 
        redirect_back_response(t('jobs.messages.job_not_created'), false)
      end
  
      rescue Stripe::CardError => e
        flash.alert = e.message
        render action: :new
    end

    def show
      @inscriptions_count = @job.inscriptions.count
      @same_category_jobs = Job.active.same_category(@job).order('created_at DESC').take(3)
      @matching_candidates = @job.show_matching_candidates(@job.skills)  
    end 
  
    def update
      @job&.update(job_params) ? redirect_to_response(t('jobs.messages.job_updated'), companies_job_path(@job)) : redirect_back_response(t('jobs.messages.job_not_updated'), false)
    end
  
    def create_inscription
      @job = current_user.jobs.find(params[:job_id])
      assign_inscription_to_job(@job, @candidate, companies_job_inscriptions_path(@job.id))
    end

    private

    def set_candidate
      @candidate = User.where(user_type: 1).find_by_id(params[:user_id])
    end

    def set_job
      @job = current_user.jobs.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to not_found_url
    end

    def job_params
      params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, 
        :remote_ok, :apply_url, :avatar, :salary_from, :salary_to, :open, :tag_list, :expiry_date, 
        :category_id, :job_type_id, :level_id, skill_ids: [])
    end
  end
end
