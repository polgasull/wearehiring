# frozen_string_literal: true

module Admins
  class JobTypesController < Admins::AdminsController
    before_action :set_job_type, only: [:update]

    def update
      @job_type.update(job_type_params) ? 
        redirect_to_response(t('job_types.messages.job_type_updated'), admins_settings_path) :
        redirect_back_response(t('job_types.messages.job_type_not_updated'), false)
    end

    private

    def set_job_type
      @job_type = JobType.find(params[:id])
    end  

    def job_type_params
      params.require(:job_type).permit!
    end

  end
end
