# frozen_string_literal: true

module Admins
  class JobsController < Admins::AdminsController
    before_action :set_job, only: [:edit, :update, :show, :destroy]

    def index
      @jobs = Job.all.filter(params).order('created_at DESC').page(params[:page]).per(30)
      @jobs_active_count = Job.where(open: true).count
      @jobs_expired_count = Job.where(open: false).count
      @jobs_count = Job.all.count  
    end

    def new
      @job = current_user.jobs.build
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

    def edit; end

    def create
      @job = current_user.jobs.build(job_params)
      
      @job.reference = "wah#{DateTime.now.year}#{SecureRandom.hex(3)}"
      @job.expiry_date = DateTime.now() + 60.days
    
      if @job.save
        TwitterService.new.send_tweet @job
        DiscordService.new.job_alert_webhook @job
        ModelMailer.new_job_scrapping(current_user, @job).deliver_later if @job.external_mail.present?
        redirect_to_response(t('jobs.messages.job_created'), @job) 
      else 
        redirect_back_response(t('jobs.messages.job_not_created'), false)
      end
    end
  
    def update
      @job.update(job_params) ? 
        redirect_back_response(t('jobs.messages.job_updated')) : 
        redirect_back_response(t('jobs.messages.job_not_updated'), false)
    end

    private

    def set_job
      @job = Job.find(params[:id])
    end
  
    def job_params
      params.require(:job).permit!
    end
  end
end
