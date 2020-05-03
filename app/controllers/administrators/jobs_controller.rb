# frozen_string_literal: true

module Administrators
  class JobsController < Administrators::AdministratorsController

    def index
      Job.all
    end

    def new
      @job = current_user.jobs.build
    end

    def edit
    end

    def create
      @job = current_user.jobs.build(job_params)
      
      reference = @job.reference = "wah#{DateTime.now.year}#{SecureRandom.hex(3)}"
  
      token = params[:stripeToken]
      job_type = params[:job_type]
      job_title = params[:title]
      card_brand = params[:user][:card_brand]
      card_exp_month = params[:user][:card_exp_month]
      card_exp_year = params[:user][:card_exp_year]
      card_last4 = params[:user][:card_last4]
  
      charge = Stripe::Charge.create(
        :amount => 9900,
        :currency => 'eur',
        :description => job_type,
        :statement_descriptor => job_title,
        :source => token
      )
  
      current_user.stripe_id = charge.id
      current_user.card_brand = card_brand
      current_user.card_exp_month = card_exp_month
      current_user.card_exp_year = card_exp_year
      current_user.card_last4 = card_last4
      current_user.save!
  
      if @job.save
        ModelMailer.new_job(current_user, @job).deliver
        redirect_to_response(t('jobs.messages.job_created'), @job) 
      else 
        redirect_back_response(t('jobs.messages.job_not_created'), false)
      end
  
      rescue Stripe::CardError => e
        flash.alert = e.message
        render action: :new
    end
  
    def update
      @job.update(job_params) ? redirect_to_response(t('jobs.messages.job_updated'), @job) : redirect_back_response(t('jobs.messages.job_not_updated'), false)
    end
  
    def destroy
      @job.destroy ? redirect_back_response(t('job_deleted')) : redirect_back_response(t('job_not_deleted'), false)
    end
  end
end