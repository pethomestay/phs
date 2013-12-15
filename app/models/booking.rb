class Booking < ActiveRecord::Base
	{
			booker: "the person who initiate a booking",
	    bookee: "the person being hired by booker",
	    confirmed: "either confirmed or unconfirmed by bookee",
	    message: "message",
	    pet_name: "pet name"
	}
	belongs_to :booker, :class_name => "User", :foreign_key => :booker_id
	belongs_to :bookee, :class_name => "User", :foreign_key => :bookee_id

	scope :need_confirmation, where(confirmed: false)
end