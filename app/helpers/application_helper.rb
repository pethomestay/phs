module ApplicationHelper
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
    haml_tag :p do
      5.times.collect do |star|
        if star < rating
          haml_tag :i, class: 'icon-star'
        else
          haml_tag :i, class: 'icon-star-empty'
        end
      end
    end
  end
end
