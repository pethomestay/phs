class Homestay
	def self.all
		(1..5).map {|n| new(n)}
	end

	def initialize(id)
		@id = id
		@title = "Example of a longer title"
		@price = 15.0
		@location = "Te Aro, Wellington"
		@description = "Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vitae elit libero, a pharetra augue. Cras mattis consectetur purus sit amet fermentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean lacinia bibendum nulla sed consectetur. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed posuere consectetur est at lobortis. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."
	end

	attr_reader :id, :title, :price, :location, :description
end
