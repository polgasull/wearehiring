# frozen_string_literal: true

module Admins
  class UserTypesController < Admins::AdminsController
    before_action :set_user_type, only: [:update]

    def update
      @user_type.update(user_type_params) ? 
        redirect_to_response(t('user_types.messages.user_type_updated'), admins_settings_path) :
        redirect_back_response(t('user_types.messages.user_type_not_updated'), false)
    end

    private

    def set_user_type
      @user_type = UserType.find(params[:id])
    end  

    def user_type_params
      params.require(:user_type).permit!
    end

  end
end
