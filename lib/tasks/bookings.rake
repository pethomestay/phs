namespace :bookings do
  desc 'Reject unresponded bookings that are older than 24 hours automatically'
  task :auto_reject => :environment do
    puts 'This task runs every hour automatically'
  end
end
