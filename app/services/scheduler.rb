class Scheduler
  attr_accessor :schedulable, :start_date, :end_date

  def initialize(schedulable, options ={})
    @schedulable = schedulable
    @start_date = options[:start_date] || DateTime.now - 7.days
    @end_date = options[:end_date] || DateTime.now
  end

  def unavailable_dates_info
    unavailable_dates = schedulable.unavailable_dates.between(start_date, end_date)
    unavailable_dates.collect do |unavailable_date|
      {
        id: unavailable_date.id,
        title: "Unavailable",
        start: unavailable_date.date.strftime("%Y-%m-%d")
      }
    end
  end

  def booked_dates_between
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

  private

  def bookings
    schedulable.bookees.finished_or_host_accepted.between(start_date, end_date)
  end

end
