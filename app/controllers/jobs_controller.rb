class JobsController < ApplicationController
  before_action :set_job, only: [:show]
  before_action :validate_is_expired!, only: [:show]

  def index
    if params[:sort_by]
      @jobs = Job.active.order_list(params[:sort_by]).page(params[:page]).per(10)
      @jobs_count = Job.active.count
    else 
      @jobs = Job.active.order('created_at DESC').filter(params).page(params[:page]).per(10)
      @jobs_count = Job.active.filter(params).count
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
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
    @job = Job.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to not_found_url
  end

  def validate_is_expired!
    if !@job.open? && !@job.user_owner_or_admin(current_user)
      return redirect_to_response(t('jobs.messages.job_expired'), root_path, false) 
    end
  end

  # def slack_ping_channel_message
  #   job_link = "[Puedes aplicar aquí ¡Mucha suerte!](https://www.wearehiring.io/ofertas-empleo-digital/#{@job.slug})"
  #   new_job_message = "Nuevo Job! #{@job.title} en #{@job.job_author} en #{@job.location} #{'(Remoto)' if @job.remote_ok?} 
  #     #{Slack::Notifier::Util::LinkFormatter.format(job_link)}"
  #   SlackService.new.ping_channel_message new_job_message, "jobs_#{@job.category.internal_name}"
  # end
end
