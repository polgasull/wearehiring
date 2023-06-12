# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :set_job, only: [:show]

  def index
    @jobs = Job.active.order('created_at DESC').filter_by(params).page(params[:page]).per(15)
    @jobs_count = Job.active.filter_by(params).count
    @last_jobs_with_logo = Job.active.where.not(avatar: nil).uniq(&:job_author).last(7)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    if request.path != job_path(@job)
      return redirect_to @job, :status => :moved_permanently
    end
    @inscriptions_count = @job.inscriptions.count
    @same_category_jobs = Job.active.same_category(@job).order('created_at DESC').take(3)
    if session.id.present?
      impressionist(@job)
    end
    @impressions = @job.impressionist_count
    @unique_impressions = @job.impressionist_count(filter: :session_hash)
  end

  private

  def set_job
    @job = Job.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to not_found_url
  end
end
