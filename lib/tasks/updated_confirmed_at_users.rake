task :updated_confirmed_at_users => :environment do
  puts "Updating users..."
  User.update_confirmed_at
  puts "done."
 end