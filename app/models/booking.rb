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
		self.owner_accepted && self.status = BOOKING_STATUS_FINISHED && user == self.bookee
	end

	def owner_view?(user)
		user == self.booker
	end

	def editable_datetime?(user)
		self.enquiry.blank? && !self.host_view?(user) && !self.owner_accepted
	end

	def confirmed_by_host(current_user)
		message = nil
		if [6, 7].include?(self.response_id)
			self.host_accepted = false
		else
			self.response_id = 5
			self.host_accepted = true

		end
		self.save!
		if self.response_id == 5
			message = 'You have confirmed the booking'
			PetOwnerMailer.booking_receipt(self).deliver
		elsif self.response_id == 6
			message = 'Guest will be informed of your unavailability'
			PetOwnerMailer.provider_not_available(self).deliver
		elsif self.response_id == 7
			message = 'Your question has been sent to guest'
			PetOwnerMailer.provider_has_question(self).deliver
		end
		self.complete_transaction(current_user)
		message
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

	def complete_transaction(current_user)
		puts
		puts "booking show and transaction completion"
		puts
		puts  self.host_accepted?.inspect
		puts
		puts  self.host_view?(current_user).inspect
		puts
		puts
		if self.host_accepted?
			if self.host_view?(current_user)
				return self.transaction.complete_payment
			end
			if self.owner_view?(current_user)
				self.remove_notification
			end
		end
	end
end