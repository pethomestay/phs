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

end
