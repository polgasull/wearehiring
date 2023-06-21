# frozen_string_literal: true

module Admins
  class CompaniesController < Admins::AdminsController
    before_action :set_user, only: [:update, :inscriptions, :show, :edit]

    def index
      @companies = User.companies.filter_by(params).order('created_at DESC').page(params[:page]).per(50)
      @all = User.companies.all
      @count = User.companies.count

      respond_to do |format|
        format.html
        format.xlsx
      end
    end

    def show
      return redirect_to_response(t('not_found'), root_path, false) unless @company
    end

    def edit
      return redirect_to_response(t('not_found'), root_path, false) unless @company
    end

    def update
      if @company.update(user_params)
        redirect_back_response(t('users.messages.user_updated'))

        respond_to do |format|
          format.html
          format.js
        end
      else 
        redirect_back_response(t('users.messages.user_not_updated'), false)
      end
    end

    private

    def set_user
      @company = User.companies.find(params[:id])
    end  

    def user_params
      params.require(:user).permit!
    end
  end
end
