# frozen_string_literal: true

module Admins
  class InscriptionsController < Admins::AdminsController
    before_action :set_job, only: [:show]

    def show
      return redirect_to_response(t('not_found'), root_path, false) unless @job
  
      @inscriptions = @job.inscriptions
      @inscriptions_count = @job.inscriptions.count

      respond_to do |format|
        format.html
        format.csv do
          headers['Content-Disposition'] = "attachment; filename=\"#{@job.title}.csv\""
          headers['Content-Type'] ||= 'text/csv'
        end
      end
    end

    private

    def set_job
      @job = Job.find_by_id(params[:job_id])
    end
  end
end