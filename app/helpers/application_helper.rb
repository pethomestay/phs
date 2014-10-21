module ApplicationHelper
  def formatted_title(title)
    title.present? ? "#{title} - PetHomeStay" : 'PetHomeStay'
  end

  def flash_class_for(type)
    case type
    when :alert
      'warning'
    when :error
      'error'
    when :notice
      'info'
    when :success
      'success'
    else
      type.to_s
    end
  end

  def new_flash_class_for(type)
    case type
    when :alert
      'warning'
    when :error
      'danger'
    when :notice
      'info'
    when :success
      'success'
    else
      type.to_s
    end
  end

  def rating_stars(rating)
    5.times.collect do |star|
       haml_tag(:i, class: "icon-star#{'-empty' if star >= rating}")
    end
  end

  def google_maps_source_url
    "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAPS_API_KEY']}&sensor=true&libraries=places"
  end

  def nil_or_not_date attribute
    (attribute.nil? or not (attribute.kind_of? Date or attribute.kind_of? DateTime or attribute.kind_of? ActiveSupport::TimeWithZone))
  end

  def nil_or_not_time attribute
    (attribute.nil? or not (attribute.kind_of? Time or attribute.kind_of? DateTime or attribute.kind_of? ActiveSupport::TimeWithZone))
  end

  def date_day_month_year_format attribute
   nil_or_not_date(attribute)? "" : attribute.strftime("%d/%m/%Y")
  end

  def hour_minute_format attribute
    nil_or_not_time(attribute) ? "" : attribute.strftime("%H:%M")
  end

  def date_day_monthname attribute
    nil_or_not_date(attribute) ? "" : attribute.to_formatted_s(:day_and_month)
  end

  def translate_state booking_state
    case booking_state
      when 'finished'                    then 'Requested'
      when 'finished_host_accepted'      then 'Booked'
      when 'host_paid'                   then 'Booked'
      when 'host_requested_cancellation' then 'Booked' # This is a state that happens in the backend. Neither the Host nor the Guest needs to know that.
      when 'rejected'                    then 'Cancelled'
      when 'guest_cancelled'             then 'Cancelled'
      when 'host_cancelled'              then 'Cancelled'
      when 'payment_authorisation_pending' then 'Enquiry'
      when 'unfinished'                  then 'Enquiry'
      else booking_state
    end
  end

  def translate_current_sign_in time
    diff = (Time.now - time).to_i
    case diff
      when 0..86400         then 'today'           # within 1 day
      when 86401..259200    then 'a few days ago'  # within 3 days
      when 259201..604800   then 'this week'       # within 7 days
      when 604801..1814400  then 'a few weeks ago' # within 21 days
      when 1814401..2678400 then 'this month'  # within 31 days
      else 'more than a month'
    end
  end
end
