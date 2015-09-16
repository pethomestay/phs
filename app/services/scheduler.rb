class Scheduler
  attr_accessor :schedulable, :start_date, :end_date

  # Initialize Scheduler
  #
  # @params
  #   schedulable [User] or any model that can be scheduled
  #   options [Hash]
  #     start_date [Date]
  #     end_date [Date]
  # @api public
  # @return [Scheduler]
  def initialize(schedulable, options ={})
    @schedulable = schedulable
    @start_date = options[:start_date] || DateTime.current - 7.days
    @end_date = options[:end_date] || DateTime.current
  end

  # Unavailable dates hash
  #
  # @api public
  # @return [Array]
  def unavailable_dates_info
    unavailable_dates.collect do |unavailable_date|
      {
        id: unavailable_date.id,
        title: "Unavailable",
        start: unavailable_date.date.strftime("%Y-%m-%d")
      }
    end
  end

  # Booked dates hash
  #
  # @api public
  # @return [Array]
  def booked_dates_info
    booked_date_values.collect do|date|
      { title: "Booked", start: date.strftime("%Y-%m-%d") }
    end
  end

  # Available dates hash
  #
  # @api public
  # @return [Array]
  def available_dates_info
    available_date_values.collect do |date|
      { title: "Available", start: date.strftime("%Y-%m-%d") }
    end
  end

  # Booking info containing all dates in given date range
  #
  # @api public
  # @return [Array]
  def booking_info
    unavailable_dates_info + booked_dates_info + available_dates_info
  end

  # Booked dates
  #
  # @api public
  # @return [Array]
  def booked_date_values
    bookings.collect do |booking|
      if booking.check_out_date == booking.check_in_date
        [booking.check_in_date]
      else
        booking_start = booking.check_in_date < start_date ? start_date : booking.check_in_date
        booking_end = booking.check_out_date > end_date ? end_date : booking.check_out_date - 1.day
        (booking_start..booking_end).to_a
      end
    end.flatten.compact.uniq
  end

  # Booked and unavailable dates
  #
  # @api public
  # @return [Array]
  def blocked_date_values
    (unavailable_date_values + booked_date_values).uniq
  end

  private

  # Bookings from schedulable
  #
  # @api private
  # @return [Booking]
  def bookings
    schedulable.bookees.finished_or_host_accepted.between(start_date, end_date)
  end

  # Collection of all dates in date range
  #
  # @api private
  # @return [Array]
  def date_range
    (start_date..end_date).to_a 
  end

  # Unavailable dates
  #
  # @api private
  # @return [Array]
  def unavailable_date_values
    unavailable_dates.map(&:date)
  end

  # Unavailable date models
  # 
  # @api private
  # @return [UnavailableDate]
  def unavailable_dates
    @unavailable_dates ||= schedulable.unavailable_dates.between(start_date, end_date)
  end

  # Available dates
  #
  # @api private
  # @return [Array]
  def available_date_values
    date_range - blocked_date_values
  end

end
