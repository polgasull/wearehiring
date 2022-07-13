class Api::V1::JobsController < ApplicationController
  def index
    jobs = Job.active.order('created_at DESC')

    render json: jobs, status: 200
  end

  def show
    job = Job.active.find(params[:id])

    if job
      render json: job, status: 200
    else
      render json: { error: 'Job not found' }
    end
  end
end
