desc "This task is called by the Heroku scheduler add-on"
task :update_expired_jobs => :environment do
  puts "Updating expired jobs..."
  Job.close_expired_jobs
  puts "done."
end