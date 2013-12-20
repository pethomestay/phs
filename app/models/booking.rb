class Booking < ActiveRecord::Base

	belongs_to :booker, class_name: 'User', foreign_key: :booker_id
	belongs_to :bookee, class_name: 'User', foreign_key: :bookee_id
	belongs_to :enquiry
	belongs_to :homestay
	has_one :transaction

	attr_accessor :fees, :payment

	scope :unfinished, where(status: BOOKING_STATUS_UNFINISHED)

	scope :needing_host_confirmation, where(owner_accepted: true, host_accepted: false, response_id: 0)

	scope :declined_by_host, where(response_id: 6, host_accepted: false)

	scope :required_response, where(response_id: 7, host_accepted: false)

	def host_view?(user)
		self.owner_accepted && self.status = BOOKING_STATUS_FINISHED && self.host_accepted == false && user == self.bookee
	end

	def editable_datetime?(user)
		self.enquiry.blank? && !self.host_view?(user)
	end

	def confirmed_by_host
		if [6, 7].include?(self.response_id)
			self.host_accepted = false
		else
			self.host_accepted = true
		end
		self.save!
	end

	def remove_notification
		self.response_id = 1
		self.save!
	end
end