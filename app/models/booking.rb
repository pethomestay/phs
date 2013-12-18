class Booking < ActiveRecord::Base

	belongs_to :booker, class_name: 'User', foreign_key: :booker_id
	belongs_to :bookee, class_name: 'User', foreign_key: :bookee_id
	belongs_to :enquiry
	belongs_to :homestay
	has_one :transaction

	attr_accessor :fees

	scope :unfinished, where(status: BOOKING_STATUS_UNFINISHED)

end