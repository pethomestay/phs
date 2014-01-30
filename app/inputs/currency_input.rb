class CurrencyInput < SimpleForm::Inputs::Base
	def input
		value = @builder.object.send(attribute_name).to_s.split('.').last
		value = value.size == 1 ? "#{value}0" : value
		"<span class='add-on'>$</span>
		#{@builder.text_field(attribute_name, input_html_options.merge(class: 'span1', value: @builder.object.send(attribute_name).to_i))}
		<span class='add-on'>.#{value}</span>".html_safe
	end
end