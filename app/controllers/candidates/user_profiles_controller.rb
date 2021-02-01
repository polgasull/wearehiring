# frozen_string_literal: true

module Candidates
  class UserProfilesController < Candidates::CandidatesController
    include InscriptionsHelper
    before_action :set_current_user

    def update
      if @user.update(user_params)
        if params[:job_id]
          @job = Job.find_by_id(params[:job_id])
          create_inscription(@job, @user) and return
        end
        SendgridService.new.update_contact @user
        return redirect_back_response(t('successfully_updated'))
      else 
        redirect_back_response(t('users.messages.user_not_updated'), false)
      end
    end

    private

    def set_current_user
      @user = current_user
      return redirect_back_response(t('devise.failure.unauthenticated'), false) unless @user
    end

    def user_params
      params.require(:user).permit(:name, :last_name, :phone, :profile_url, :current_position, 
      :picture_url, :description, :github, :pinterest, :behance, :personal_website, skill_ids: [])
    end
  end
end