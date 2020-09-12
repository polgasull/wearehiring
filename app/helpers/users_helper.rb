# frozen_string_literal: true

module UsersHelper

  def user_inscribed_to(job)  
    current_user.inscriptions.any? {|u| u[:job_id] == job.id}
  end

  def profile_is_completed(current_user)
    %w( picture_url profile_url phone current_position ).all? { |attr| current_user[attr].present? }
  end
end