class Booking < ActiveRecord::Base
	{
			# guest will enter the following information
			"guest_name" => "Ali",
	    "pet_name" => "Catty Perry",
	    "message" => "",

	    # host will enter the following information
	    "check_in" => "time n date",
	    "check_out" => "time n date",
	    "no_of_nights" => "#_of_nights",
	    "rate_per_night" => "get from guest",

	    # calculations
	    "subtotal" => "#_of_nights * rate_per_night",
	    "fee" => "from where?",
	    "total" => "subtotal + fee"
	}
end