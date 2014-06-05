desc "if a state is finished and host has accepted change state to our new state"
task :update_finished_state_for_host_accepted => :environment do
    #lets use each to ensure  each user in the db has a mobile number value
    Booking.all.each{ | b |
      if b.state?(:finished) and b.host_accepted #either nil or ''
        b.host_accepts_booking
      end
      b.save!
    }
end