desc "This task is called by the Heroku scheduler add-on"
task :update_expired_jobs => :environment do
  puts "Updating expired jobs..."
  Job.close_expired_jobs
  puts "done."
end

task :job_upgrade_email_proposal => :environment do
  puts "Sending upgrade job proposal emails..."
  Job.send_upgrade_job_email_proposal
  puts "done."
end

task :user_update_residence_info => :environment do
  puts "Updating user residence info..."
  User.update_residence_info
  puts "done."
end
