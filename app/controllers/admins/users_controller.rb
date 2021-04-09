# frozen_string_literal: true

module Admins
  class UsersController < Admins::AdminsController
    before_action :set_user, only: [:update, :inscriptions, :show]

    def index
      @users = User.all.filter(params).order('created_at DESC').page(params[:page]).per(50)
      @all_users = User.all
      @companies_count = User.where(user_type: 2).count
      @candidates_count = User.where(user_type: 1).count
      @ambassadors_count = User.where(user_type: 4).count
      @matching_users_count = candidates_with_skills.count
      @candidates_not_visible = User.where(visible: false).count

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
        SendgridService.new.update_contact @user
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

    def candidates_with_skills
      candidates = []
      User.where(user_type: 1).each do |user|
        candidates << user if user.skills.any?
      end
      candidates
    end
  end
end