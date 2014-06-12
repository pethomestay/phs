desc "if a state is finished and host has accepted change state to our new state and update 'host paid' to 'host_paid'"
task :update_states_for_state_machine => :environment do
    #lets use each to ensure  that we use our new state for a finished booking that the host has accepted
    puts "cycling through the bookings"
    Booking.all.each{ | b |
      if b.state?(:finished) and b.host_accepted #either nil or ''
        b.host_accepts_booking
      end
      #Ensure that 'host paid' is now a valid state 'host_paid'
      if b.state == 'host paid'
        b.state =  :host_paid
      end
      b.save!
    }
    puts "finished updating states for state machine!"
end