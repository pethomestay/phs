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

	scope :accepted_by_host, where(response_id: 5, host_accepted: true)

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
			self.response_id = 5
			self.host_accepted = true
		end
		self.save!
		if self.response_id == 5
			PetOwnerMailer.booking_receipt(self).deliver
		elsif self.response_id == 6
			PetOwnerMailer.provider_unavailable(self).deliver
		elsif self.response_id == 7
			PetOwnerMailer.provider_undecided(self).deliver
		end
	end

	def remove_notification
		self.response_id = 1
		self.save!
	end

	def update_transaction_by(params)
		self.number_of_nights = params['number_of_nights'].to_i
		self.check_in_date = params['check_in_date']
		self.check_out_date = params['check_out_date']
		self.subtotal = self.number_of_nights * self.cost_per_night
		self.amount = self.subtotal + TRANSACTION_FEE
		self.save!

		self.transaction.amount = self.amount
		self.transaction.time_stamp = Time.now.gmtime.strftime("%Y%m%d%H%M%S")
		fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{self.transaction.type_code}|#{self.transaction.
				reference}|#{self.transaction.actual_amount}|#{self.transaction.time_stamp}"
		require 'digest/sha1'
		self.transaction.merchant_fingerprint = Digest::SHA1.hexdigest(fingerprint_string)
		self.transaction.save!

		{
		    booking_subtotal: self.subtotal,
		    booking_amount: self.amount,
		    transaction_actual_amount: self.transaction.actual_amount,
		    transaction_time_stamp: self.transaction.time_stamp,
		    transaction_merchant_fingerprint: self.transaction.merchant_fingerprint
		}
	end

	def update_booking_by(params)
		self.message = params['message']
		self.save!
	end
end