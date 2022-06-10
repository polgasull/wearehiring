# frozen_string_literal: true

module Candidates
  class UserProfilesController < Candidates::CandidatesController
    include InscriptionsHelper

    def show
      return redirect_to_response(t('not_found'), root_path, false) unless current_user

      @inscriptions = current_user.inscriptions.take(10)
    end

    def update
      if current_user.update(user_params)
        if params[:job_id]
          @job = Job.find_by_id(params[:job_id])
          assign_inscription_to_job(@job, current_user, false, false) and return
        end
        return redirect_back_response(t('successfully_updated'))
      else 
        redirect_back_response(t('users.messages.user_not_updated'), false)
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :last_name, :phone, :profile_url, :current_position, 
      :picture_url, :description, :github, :pinterest, :behance, :personal_website,
      :salary_to, :salary_from, :location, :experience, :visible, skill_ids: [])
    end
  end
end
