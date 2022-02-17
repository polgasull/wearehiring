# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :set_job, only: [:show]
  before_action :validate_is_expired!, only: [:show]

  def index
    if params[:sort_by]
      @jobs = Job.active.order_list(params[:sort_by]).page(params[:page]).per(10)
      @jobs_count = Job.active.count
    else 
      @jobs = Job.active.order('created_at DESC').filter_by(params).page(params[:page]).per(10)
      @jobs_count = Job.active.filter_by(params).count
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    if request.path != job_path(@job)
      return redirect_to @job, :status => :moved_permanently
    end
    return redirect_to_response(t('not_found'), root_path, false) unless @job
    @inscriptions_count = @job.inscriptions.count
    @same_category_jobs = Job.active.same_category(@job).order('created_at DESC').take(3)
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
    @job = Job.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to not_found_url
  end

  def validate_is_expired!
    if !@job.open? && !@job.user_owner_or_admin(current_user)
      return redirect_to_response(t('jobs.messages.job_expired'), root_path, false) 
    end
  end
end
