require 'digest/sha1'

class Booking < ActiveRecord::Base
	belongs_to :booker, class_name: 'User', foreign_key: :booker_id
	belongs_to :bookee, class_name: 'User', foreign_key: :bookee_id
	belongs_to :homestay
	belongs_to :enquiry

	has_one :transaction, dependent: :destroy
	has_one :mailbox, dependent: :destroy

	validates_presence_of :bookee_id, :booker_id, :check_in_date, :check_out_date

	attr_accessor :fees, :payment, :public_liability_insurance, :phs_service_charge, :host_payout

	scope :unfinished, where(status: BOOKING_STATUS_UNFINISHED)

	scope :needing_host_confirmation, where(owner_accepted: true, host_accepted: false, response_id: 0)

	scope :declined_by_host, where(response_id: 6, host_accepted: false)

	scope :required_response, where(response_id: 7, host_accepted: false)

	scope :accepted_by_host, where(response_id: 5, host_accepted: true)

	scope :finished_and_host_accepted, where(host_accepted: true, status: BOOKING_STATUS_FINISHED)

	after_create :create_mailbox

	def create_mailbox
		mailbox = nil
		if self.enquiry_id.blank?
			mailbox = Mailbox.find_or_create_by_booking_id self.id
		else
			mailbox = Mailbox.find_or_create_by_enquiry_id self.enquiry_id
		end
		mailbox.update_attributes! booking_id: self.id, enquiry_id: self.enquiry_id, guest_mailbox_id: self.booker_id,
		                           host_mailbox_id: self.bookee_id
		mailbox.reload
	end

	def host_view?(user)
		self.owner_accepted? && self.status == BOOKING_STATUS_FINISHED && user == self.bookee
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
		self.mailbox.messages.create! user_id: bookee_id, message_text: self.response_message

		if self.response_id == 5
			message = 'You have confirmed the booking'
			self.save!
			PetOwnerMailer.booking_confirmation(self).deliver
			ProviderMailer.booking_confirmation(self).deliver
		elsif self.response_id == 6
			message = 'Guest will be informed of your unavailability'
			self.status = BOOKING_STATUS_REJECTED
			self.save!
			PetOwnerMailer.provider_not_available(self).deliver
		elsif self.response_id == 7
			message = 'Your question has been sent to guest'
			old_message = self.response_message
			self.response_message = nil
			self.save!
			PetOwnerMailer.provider_has_question(self, old_message).deliver
		end
		self.complete_transaction(current_user)
		message
	end

	def remove_notification
		self.response_id = 1
		self.save!
	end

	def update_transaction_by(number_of_nights=nil, check_in_date=nil, check_out_date=nil)
		if number_of_nights.blank? || check_in_date.blank? || check_out_date.blank?
			return { error: true }
		end
		self.number_of_nights = number_of_nights.to_i
		self.check_in_date = check_in_date
		self.check_out_date = check_out_date

		self.subtotal = self.number_of_nights * self.cost_per_night
		self.amount = self.subtotal + self.transaction_fee
		self.save!

		self.transaction.amount = self.amount
		self.transaction.time_stamp = Time.now.gmtime.strftime("%Y%m%d%H%M%S")
		fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{self.transaction.type_code}|#{self.transaction.
				reference}|#{self.transaction.actual_amount}|#{self.transaction.time_stamp}"

		self.transaction.merchant_fingerprint = Digest::SHA1.hexdigest(fingerprint_string)
		self.transaction.save!

		{
		    booking_subtotal: self.subtotal,
		    booking_amount: self.amount,
		    transaction_fee: self.transaction_fee,
		    transaction_actual_amount: self.transaction.actual_amount,
		    transaction_time_stamp: self.transaction.time_stamp,
		    transaction_merchant_fingerprint: self.transaction.merchant_fingerprint
		}
	end

	def complete_transaction(current_user)
		if self.host_accepted?
			if self.host_view?(current_user)
				return self.transaction.complete_payment
			end
			if self.owner_view?(current_user)
				self.remove_notification
			end
		end
	end

	def phs_service_charge
		(self.subtotal * 0.15).to_i
	end

	def public_liability_insurance
		(self.number_of_nights * 2).to_i
	end

	def host_payout_deduction
		public_liability_insurance + phs_service_charge + transaction_fee
	end

	def host_payout
		amount - host_payout_deduction
	end

	def transaction_fee
		credit_card_fee
	end

	def credit_card_fee
		fee = (subtotal * 0.025).to_i
		fee < 1 ? 1 : fee
	end

	def message_update(new_message)
		old_message = self.message
		self.message = new_message
		self.save!

		if old_message.blank?
			self.mailbox.messages.create! message_text: new_message, user_id: self.booker_id
		else
			message = Message.find_by_user_id_and_mailbox_id(self.booker_id, self.mailbox.id)
			message.message_text = new_message
			message.save!
		end
	end

	def host_booking_status
		pending_or_rejected = (status == BOOKING_STATUS_REJECTED) ? 'Rejected' : 'Pending'
		"Booking $#{self.host_payout}.00 - #{self.host_accepted? ? 'Accepted' : pending_or_rejected}"
	end

	def guest_booking_status
		pending_or_rejected = (status == BOOKING_STATUS_REJECTED) ? 'Rejected' : 'Pending'
		"Booking $#{self.amount}.00 - #{self.host_accepted? ? 'Accepted' : pending_or_rejected}"
	end
end