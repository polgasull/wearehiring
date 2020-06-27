# frozen_string_literal: true

module Admins
  class UsersController < Admins::AdminsController
    before_action :set_user, only: [:update, :inscriptions]

    def index
      @users = User.all.order('created_at DESC').page(params[:page]).per(50)
      @all_users = User.all
      @companies = User.where(user_type: 2).count
      @candidates = User.where(user_type: 1).count

      respond_to do |format|
        format.html
        format.csv do
          headers['Content-Disposition'] = "attachment; filename=\"wah_users_#{Date.today}.csv\""
          headers['Content-Type'] ||= 'text/csv'
        end
      end
    end 

    def update
      @user.update(user_params) ? redirect_to_response(t('users.messages.user_updated'), admins_users_path) : redirect_back_response(t('users.messages.user_not_updated'), false)
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