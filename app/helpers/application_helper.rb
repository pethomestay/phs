module ApplicationHelper
  def formatted_title(title)
    title.present? ? "#{title} - PetHomeStay" : 'PetHomeStay'
  end

  def flash_class_for(type)
    case type
      when :alert
        "warning"
      when :error
        "error"
      when :notice
        "info"
      when :success
        "success"
      else
        type.to_s
    end
  end

  def rating_stars(rating)
    5.times.collect do |star|
      if star < rating
        haml_tag :i, class: 'icon-star'
      else
        haml_tag :i, class: 'icon-star-empty'
      end
    end
  end

  def country_priority
    important_countries = %w{AU NZ}
    if request.location
      priority = [request.location.country_code].concat(important_countries)
    else
      priority = important_countries
    end

    priority.uniq
  end

  def google_maps_source_url
    "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAPS_API_KEY']}&sensor=true&libraries=places"
  end
end
