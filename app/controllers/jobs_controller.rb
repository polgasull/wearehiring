# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :set_job, only: [:show]

  def index
    @jobs = Job.active.order('created_at DESC').filter_by(params).page(params[:page]).per(15)
    @jobs_count = Job.active.filter_by(params).count

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
    impressionist(@job)
    @impressions = @job.impressionist_count
    @unique_impressions = @job.impressionist_count(filter: :session_hash)
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
    @job = Job.friendly.active.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to not_found_url
  end
end
