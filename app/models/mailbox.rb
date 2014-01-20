class Mailbox < ActiveRecord::Base
	belongs_to :guest_mailbox, class_name: 'User', foreign_key: :guest_mailbox_id
	belongs_to :host_mailbox, class_name: 'User', foreign_key: :host_mailbox_id
	has_many :messages, dependent: :delete_all
	belongs_to :enquiry
	belongs_to :booking

	validates_presence_of :guest_mailbox_id, :host_mailbox_id
	validate :enquiry_or_booking_presence

	def enquiry_or_booking_presence
		if enquiry_id.blank? && booking_id.blank?
			self.errors.add(:enquiry_id, "can't be blank")
		end
	end

	def subject
		booking.blank? ? enquiry : booking
	end

	def subject_message
		message = booking_subject_message unless booking.check_in_date.blank? unless booking.blank?
		message = enquiry_subject_message if message.blank?
		message
	end

	def booking_subject_message
		"Booking for #{booking.check_in_date.to_formatted_s(:day_and_month)}"
	end

	def enquiry_subject_message
		enquiry.message.blank? ? 'this enquiry has no message' : enquiry.message
	end

	def subject_dates
		if subject.check_in_date.blank? || subject.check_out_date.blank?
			absent_dates_message
		else
			dates_message
		end
	end

	def dates_message
		"Check in date: #{subject.check_in_date.strftime('%d/%m/%Y')} - Check out date: #{subject.check_out_date.strftime('%d/%m/%Y')}"
	end

	def absent_dates_message
		'check-in or check-out date are absent'
	end
end