# frozen_string_literal: true

module Admins
  class UsersController < Admins::AdminsController
    before_action :set_user, only: [:update, :inscriptions]

    def index
      @users = User.all.filter(params).order('created_at DESC').page(params[:page]).per(50)
      @all_users = User.all
      @companies = User.where(user_type: 2).count
      @candidates = User.where(user_type: 1).count

      respond_to do |format|
        format.html
        format.xlsx
      end
    end 

    def update
      if @user.update(user_params)
        SendgridService.new.update_contact @user if Rails.env.production?
        redirect_back_response(t('users.messages.user_updated'))
      else 
        redirect_back_response(t('users.messages.user_not_updated'), false)
      end
    end

    def inscriptions
      @inscriptions = @user.inscriptions
      @inscriptions_count = @user.inscriptions.count
    end  

    private

    def set_user
      @user = User.find(params[:id])
    end  

    def user_params
      params.require(:user).permit!
    end
  end
end