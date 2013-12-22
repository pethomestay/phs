class TimePickerInput < SimpleForm::Inputs::Base
	def input
		"#{@builder.text_field(attribute_name, input_html_options.merge(class: 'span2', 'data-format' => 'hh:mm'))}
		<span class='add-on'>
			<i data-time-icon='icon-time' data-date-icon='icon-calender' class='icon-time'></i>
		</span>".html_safe
	end
end