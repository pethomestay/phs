class Mailbox < ActiveRecord::Base
	belongs_to :guest_mailbox, class_name: 'User', foreign_key: :guest_mailbox_id
	belongs_to :host_mailbox, class_name: 'User', foreign_key: :host_mailbox_id
	belongs_to :enquiry
	belongs_to :booking

	has_many :messages, dependent: :destroy

	validates_presence_of :guest_mailbox_id, :host_mailbox_id
	validate :enquiry_or_booking_presence

	scope :with_finished_bookings, ->(user) { where("guest_mailbox_id = ? OR host_mailbox_id = ?", user.id, user.id).
			order('created_at DESC') } # Depreciate this when we move completely to the new dashboard
	scope :as_guest, ->(user) { where("guest_mailbox_id = ?", user.id).order('guest_read ASC') } # Retrieve all conversations relevant in Guest view
	scope :as_host,  ->(user) { where("host_mailbox_id = ?", user.id).order('host_read ASC') } # Retrieve all conversations relevant in Host view

	def enquiry_or_booking_presence
		if enquiry_id.blank? && booking_id.blank?
			self.errors.add(:enquiry_id, "can't be blank")
			self.errors.add(:booking_id, "can't be blank")
		end
	end

	def subject
		booking.blank? ? enquiry : booking
	end

	def subject_message
		message = booking_subject_message unless booking.check_in_date.blank? unless booking.blank?
		message = "Enquiry for #{enquiry.homestay.title}" if message.blank?
		message
	end

	def subject_is_finished
		booking.blank? ? true : !booking.state?(:unfinished)
	end

	def booking_subject_message
		"Booking for #{booking.check_in_date.to_formatted_s(:day_and_month)}"
	end

	def subject_dates
		if subject.check_in_date.blank? || subject.check_out_date.blank?
			absent_dates_message
		else
			dates_message
		end
	end

	def dates_message
		"#{subject.check_in_date.strftime('%d/%m/%Y')} to #{subject.check_out_date.strftime('%d/%m/%Y')}"
	end

	def absent_dates_message
		'check-in or check-out date are absent'
	end

	def host_booking?(current_user)
		!self.booking.blank? && (current_user == self.host_mailbox) && self.booking.owner_accepted? &&
				!self.booking.host_accepted? && (!self.booking.state?(:rejected))
	end

	def read_by?(current_user)
		if current_user == guest_mailbox
		  guest_read?
		elsif current_user == host_mailbox
			host_read?
		end
	end

	def read_by(current_user)
		if current_user == guest_mailbox
			self.guest_read = true
		elsif current_user == host_mailbox
			self.host_read = true
		end
		self.save!
	end

	def read_for(current_user)
		if current_user == guest_mailbox
			self.host_read = false
		elsif current_user == host_mailbox
			self.guest_read = false
		end
		self.save!
	end
end
