class CurrencyInput < SimpleForm::Inputs::Base
	def input
		"<span class='add-on'>$</span>
		#{@builder.text_field(attribute_name, input_html_options.merge(class: 'span1'))}
		<span class='add-on'>.00</span>".html_safe
	end
end