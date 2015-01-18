class Host::CalendarController < Host::HostController
  skip_before_filter :host_filters
  skip_before_filter :track_session_variables

  # GET /host/calendar/availability
  # Params
  #   start: start date in the format of YYYY-MM-DD
  #   end  : end date in the format of YYYY-MM-DD
  # Optional params
  #   host_id: user id of homestay owner
  # Response
  #   [
  #     ..
  #     [
  #       date: YYYY-MM-DD,
  #       status: 'booked'
  #     ]
  #     ..
  #     [
  #       date: YYYY-MM-DD,
  #       status: 'unavailable',
  #       unavailable_date_id: corresponding unavailable date id
  #     ]
  #     ..
  #   ]
  def availability
    start_date = Date.parse(params[:start])
    end_date   = Date.parse(params[:end])
    # Booked dates
    # Note: Most of this part needs to be kept in sync with Guest's CalendarController
    host = params[:host_id].present? ? User.find(params[:host_id]) : current_user # This line is an exception
    head :internal_server_error and return unless host.present?
    bookings = host.bookees # This line is an exception
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
    # Unavailable dates
    unavailable_dates = host.unavailable_dates
                    .between(start_date, end_date)
                    .collect do |u_d|
                      {
                        date: u_d.date.strftime("%Y-%m-%d"),
                        status: 'unavailable',
                        unavailable_date_id: u_d.id,
                      }
                    end
    availability.concat unavailable_dates
    render json: availability
  end
end
