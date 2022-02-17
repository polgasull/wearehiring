# frozen_string_literal: true

module Admins
  class LevelsController < Admins::AdminsController
    before_action :set_level, only: [:update]

    def update
      @level.update(level_params) ? 
        redirect_to_response(t('levels.messages.level_updated'), admins_settings_path) :
        redirect_back_response(t('levels.messages.level_not_updated'), false)
    end

    private

    def set_level
      @level = Level.find(params[:id])
    end  

    def level_params
      params.require(:level).permit!
    end

  end
end
