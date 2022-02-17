# frozen_string_literal: true

module Admins
  class SkillsController < Admins::AdminsController
    before_action :set_skill, only: [:update]

    def create
      skill = Skill.new(skill_params)

      skill.save ? redirect_back_response(t('skills.messages.skill_updated')) : redirect_back_response(t('skills.messages.skill_not_updated'), false)
    end

    def update
      @skill.update(skill_params) ? 
        redirect_to_response(t('skills.messages.skill_updated'), admins_settings_path) :
        redirect_back_response(t('skills.messages.skill_not_updated'), false)
    end

    private

    def set_skill
      @skill = Skill.find(params[:id])
    end  

    def skill_params
      params.require(:skill).permit!
    end

  end
end
