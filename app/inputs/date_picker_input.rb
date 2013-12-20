class DatePickerInput < SimpleForm::Inputs::Base
	def input
		"#{@builder.text_field(attribute_name, input_html_options.merge(class: 'span2', 'data-format' => 'dd/MM/yyyy'))}
		<span class='add-on'>
			<i data-time-icon='icon-time' data-date-icon='icon-calendar' class='icon-calendar'></i>
		</span>".html_safe
	end
end
