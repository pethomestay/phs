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

	def mailbox_subject
		subject_message = "Booking for #{booking.check_in_date.to_formatted_s(:day_and_month)}" unless booking.check_in_date.blank? unless booking.blank?
		if subject_message.blank?
			subject_message = enquiry.message.blank? ? 'No enquiry message' : enquiry.message
		end
		subject_message
	end

	def type
		booking.blank? ? 'Enquiry' : 'Booking'
	end

	def all_dates
		if self.booking.blank?
			if self.enquiry
				return "Check in date: #{self.enquiry.check_in_date.strftime("%d/%m/%Y")} - Check out date: #{self.enquiry.check_out_date.strftime("%d/%m/%Y")}"
			end
		else
			return "Check in date: #{self.booking.check_in_date.strftime("%d/%m/%Y")} - Check out date: #{self.booking.check_out_date.strftime("%d/%m/%Y")}"
		end
	end
end