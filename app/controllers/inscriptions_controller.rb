class InscriptionsController < ApplicationController
  before_action :set_job, only: [:create]

  def create
    @inscription = @job.inscriptions.build
    @inscription.save
    redirect_to @inscription.job
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end
end