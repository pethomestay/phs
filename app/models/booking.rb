require 'digest/sha1'

class Booking < ActiveRecord::Base
	belongs_to :booker, class_name: 'User', foreign_key: :booker_id
	belongs_to :bookee, class_name: 'User', foreign_key: :bookee_id
	belongs_to :homestay
	belongs_to :enquiry

	has_one :transaction, dependent: :destroy
	has_one :mailbox, dependent: :destroy

	validates_presence_of :bookee_id, :booker_id, :check_in_date, :check_out_date

	attr_accessor :fees, :payment, :public_liability_insurance, :phs_service_charge, :host_payout, :pet_breed, :pet_age,
	              :pet_date_of_birth

	scope :unfinished, where(status: BOOKING_STATUS_UNFINISHED)

	scope :needing_host_confirmation, where(owner_accepted: true, host_accepted: false, response_id: 0)

	scope :declined_by_host, where(response_id: 6, host_accepted: false)

	scope :required_response, where(response_id: 7, host_accepted: false)

	scope :accepted_by_host, where(response_id: 5, host_accepted: true)

	scope :finished_and_host_accepted, where(host_accepted: true, status: BOOKING_STATUS_FINISHED).order('created_at DESC')

	scope :finished_and_host_accepted_or_host_paid, where('status IN (?) AND host_accepted is true', [
			BOOKING_STATUS_FINISHED, BOOKING_STATUS_HOST_PAID]).order('created_at DESC')

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

	def self.to_csv(options = {})
		CSV.generate(options) do |csv|
			csv << [
				'Guest name', 'Guest address', 'Pet name', 'Pet breed', 'Pet age', 'Check-in Date', 'Check-in Time',
			  'Check-out Date', 'Check-out Time', 'Host name', 'Homestay Title', 'Host Address', '# of 24 hour period',
			  'Transaction Reference', 'Total', 'Insurance Fees', 'PHS Fee', 'Host Payout', 'Status'
			]

			all.each do |booking|
				booker = booking.booker
				pet = booker.pet
				host = booking.bookee
				csv << [
					booker.name.capitalize, booker.complete_address, pet.name, pet.breed, pet.age,
					booking.check_in_date.to_formatted_s(:year_month_day), booking.check_in_time.strftime("%H:%M"),
			    booking.check_out_date.to_formatted_s(:year_month_day), booking.check_out_time.strftime("%H:%M"),
			    host.name.capitalize, booking.homestay.title, host.complete_address, booking.number_of_nights,
			    booking.transaction.reference.to_s, "$#{booking.transaction.amount}", "$#{booking.public_liability_insurance}",
			    "$#{booking.phs_service_charge}", "$#{booking.host_payout}",
			    (booking.status == BOOKING_STATUS_HOST_PAID) ? 'Paid' : 'Not Paid'
				]
			end
		end
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
			results = self.complete_transaction(current_user)
			if results.class == String
				message = 'An error has occurred. Sorry for inconvenience. Please consult PetHomeStay Team'
				UserMailer.error_report('host confirming transaction', results).deliver
			else
				self.save!
				PetOwnerMailer.booking_confirmation(self).deliver
				ProviderMailer.booking_confirmation(self).deliver
			end

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
		self.amount = self.calculate_amount
		self.save!

		self.transaction.amount = self.amount
		self.transaction.time_stamp = Time.now.gmtime.strftime("%Y%m%d%H%M%S")
		fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{self.transaction.type_code}|#{self.transaction.
				reference}|#{self.transaction.actual_amount}|#{self.transaction.time_stamp}"

		self.transaction.merchant_fingerprint = Digest::SHA1.hexdigest(fingerprint_string)
		self.transaction.save!

		{
		    booking_subtotal: self.subtotal.to_s,
		    booking_amount: self.amount.to_s,
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
		actual_value_figure(transaction_mode_value(self.subtotal * 0.15))
	end

	def public_liability_insurance
		actual_value_figure(transaction_mode_value(self.number_of_nights * 2))
	end

	def host_payout_deduction
		transaction_mode_value(public_liability_insurance.to_f + phs_service_charge.to_f)
	end

	def host_payout
		actual_value_figure(subtotal - host_payout_deduction)
	end

	def transaction_fee
		actual_value_figure(credit_card_fee)
	end

	def credit_card_fee
		transaction_mode_value(subtotal * 0.025)
	end

	def fees
		actual_value_figure(credit_card_fee)
	end

	def actual_amount
		return '00.00' if self.amount.blank?
		actual_value_figure(amount)
	end

	def actual_value_figure(value)
		value = self.send(value) if value.class == Symbol
		fraction = value.to_s.split('.').last
		if fraction.size == 1
			"#{value.to_s}0"
		elsif fraction.size == 2
			value.to_s
		elsif fraction.size > 2
			value.round(2).to_s
		end
	end

	def calculate_amount
		transaction_mode_value(self.subtotal + self.transaction_fee.to_f)
	end

	def transaction_mode_value(value)
		if live_mode_rounded_value?
			return value.round(2)
		else
			integer_part = value.to_s.split('.')[0]
			fraction_part = value.to_s.split('.')[1]
			fraction_part = fraction_part.to_i > 0 ? '.08' : '.00'
			(integer_part + fraction_part).to_f
		end
	end

	def live_mode_rounded_value?
		ENV['LIVE_MODE_ROUNDED_VALUE'] == 'true' ? true : false
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
		"Booking $#{self.host_payout} - #{self.host_accepted? ? 'Accepted' : pending_or_rejected}"
	end

	def guest_booking_status
		pending_or_rejected = (status == BOOKING_STATUS_REJECTED) ? 'Rejected' : 'Pending'
		"Booking $#{self.actual_amount} - #{self.host_accepted? ? 'Accepted' : pending_or_rejected}"
	end

	def actual_status
		if self.status == BOOKING_STATUS_UNFINISHED
			BOOKING_STATUS_UNFINISHED
		elsif self.status == BOOKING_STATUS_FINISHED && !self.host_accepted?
			'awaiting host response'
		elsif self.status == BOOKING_STATUS_FINISHED && self.host_accepted?
			'host accepted but not paid'
		elsif self.status == BOOKING_STATUS_REJECTED
			'host rejected'
		elsif self.status == BOOKING_STATUS_HOST_PAID
			'host has been paid'
		else
			'invalid booking state'
		end
	end
end