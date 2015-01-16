class Guest::CalendarController < Guest::GuestController
  skip_before_filter :track_session_variables
  # GET /guest/calendar/availability
  # Params
  #   start: start date in the format of YYYY-MM-DD
  #   end  : end date in the format of YYYY-MM-DD
  # Response
  #   [
  #     ..
  #     [
  #       date: YYYY-MM-DD,
  #       status: 'booked',
  #     ]
  #     ..
  #   ]
  def availability
    start_date = Date.parse(params[:start])
    end_date   = Date.parse(params[:end])
    # Note: do not display unavailable dates for Guest.
    #       Display only booked dates as a Guest.
    bookings = current_user.bookers
               .booked
               .where("check_in_date <= ? and check_out_date >= ?", end_date, start_date)
               .select('id, check_in_date, check_out_date')
    availability = bookings.collect do |b|
      b_start = b.check_in_date < start_date ? start_date : b.check_in_date
      b_end   = b.check_out_date > end_date ? end_date : b.check_out_date
      (b_start..b_end).collect do |d|
        {
          date: d.strftime('%Y-%m-%d'),
          status: 'booked',
        }
      end
    end.flatten.uniq.sort! { |a,b| a[:date] <=> b[:date] }
    render json: availability
  end
end
