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
      'alert-warning'
    when :error
      'alert-danger'
    when :notice
      'alert-info'
    when :success
      'alert-success'
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
end
