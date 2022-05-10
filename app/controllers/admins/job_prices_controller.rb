# frozen_string_literal: true

module Admins
  class JobPricesController < Admins::AdminsController
    before_action :set_job_price, only: [:update]

    def create
      job_price = JobPrice.new(job_price_params)

      job_price.save ? 
        redirect_back_response(t('job_prices.messages.job_price_updated')) : 
        redirect_back_response(t('job_prices.messages.job_price_not_updated'), false)
    end

    def update
      @job_price.update(job_price_params) ? 
        redirect_to_response(t('job_prices.messages.job_price_updated'), admins_settings_path) :
        redirect_back_response(t('job_prices.messages.job_price_not_updated'), false)
    end

    private

    def set_job_price
      @job_price = JobPrice.find(params[:id])
    end

    def job_price_params
      params.require(:job_price).permit!
    end

  end
end
