# frozen_string_literal: true

module Admins
  class UsersController < Admins::AdminsController
    before_action :set_user, only: [:update, :inscriptions, :show]

    def index
      @users = User.all.filter_by(params).order('created_at DESC').page(params[:page]).per(30)
      @all_users = User.all
      @companies_count = User.where(user_type: 2).count
      @candidates_count = User.where(user_type: 1).count
      @candidates_not_visible = User.where(visible: false).count
      @candidates_without_skills = User.where(user_type: 1).without_skills.count

      respond_to do |format|
        format.html
        format.xlsx
      end
    end 

    def show
      return redirect_to_response(t('not_found'), root_path, false) unless @user
    end

    def update
      if @user.update(user_params)
        respond_to do |format|
          format.js
        end
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
