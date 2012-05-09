class Homestay
	def self.all
		(1..5).map {|n| new(n)}
	end

	def initialize(id)
		@id = id
		@title = "Example"
		@price = 15.0
		@location = "Welly"
		@description = "Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vitae elit libero, a pharetra augue. Cras mattis consectetur purus sit amet fermentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
	end

	attr_reader :id, :title, :price, :location, :description
end
