# frozen_string_literal: true

module UsersHelper

  def user_inscribed_to(job)  
    current_user.inscriptions.any? {|u| u[:job_id] == job.id}
  end 
end