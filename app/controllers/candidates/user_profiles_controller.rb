# frozen_string_literal: true

module Candidates
  class UserProfilesController < Candidates::CandidatesController
    include InscriptionsHelper

    def update
      if current_user.update(user_params)
        SendgridService.new.update_contact current_user
        if params[:job_id]
          @job = Job.find_by_id(params[:job_id])
          assign_inscription_to_job(@job, current_user, false) and return
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
      :salary_to, :salary_from, :visible, skill_ids: [])
    end
  end
end