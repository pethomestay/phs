desc "This task is called by the Heroku scheduler add-on"
task :auto_decline => :environment do
  puts "Now auto-declining old bookings"
  Booking.auto_decline
  puts "Completed auto-decline old bookings"
end
