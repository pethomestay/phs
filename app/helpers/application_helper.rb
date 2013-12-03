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
       haml_tag(:i, class: "icon-star#{'-empty' if star >= rating}")
    end
  end

  def google_maps_source_url
    "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAPS_API_KEY']}&sensor=true&libraries=places"
  end

	def form_text_field(options)
	  required_class = options[:required] ? "required" : ""
	  field_type = options[:type] == "text" ? "type='text'" : ""

	  input_field = "<#{options[:type] == "text" ? "input" : "textarea"} class='#{required_class} string #{options[:class]}'
	                #{field_type} name='#{options[:name]}' value='#{options[:value]}' #{options[:disabled] ? 'disabled' : ''}
	                #{options[:type] == "text" ? "" : "rows='#{options[:rows]}'"} #{options[:type] == "text" ? "/>" : "></textarea>"}"

	  label_field = "<label class='string control-label #{required_class}'>
									#{options[:required] ? "<abbr title='required'>*</abbr>" : ""}#{options[:label]}</label>"

		"<div class='control-group string #{required_class}'>
		  #{label_field}
			<div class='controls'>
			  <div class='#{options[:datetime] ? "input-append date" : ""}'>
			    #{input_field}
					#{options[:datetime] ? "<span class='add-on'><i class='icon-calendar'></i></span>" : ""}
				</div>
			</div>
		</div>".html_safe
	end
end
