require 'digest/sha1'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :current_password, :accept_house_rules, :accept_terms

  has_one :homestay
  has_many :pets
  has_many :enquiries
  has_many :bookers, class_name: 'Booking', foreign_key: :booker_id
  has_many :bookees, class_name: 'Booking', foreign_key: :bookee_id
  has_many :cards
  has_many :host_mailboxes, class_name: 'Mailbox', foreign_key: :host_mailbox_id
  has_many :guest_mailboxes, class_name: 'Mailbox', foreign_key: :guest_mailbox_id
  has_many :messages

  has_many :given_feedbacks, class_name: 'Feedback'
  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'subject_id'

  validates_presence_of :first_name, :last_name, :date_of_birth, :address_1, :address_suburb,
                        :address_city, :address_country

  validates_acceptance_of :accept_house_rules, on: :create
  validates_acceptance_of :accept_terms, on: :create

  scope :last_five, order('created_at DESC').limit(5)

  def name
    "#{first_name} #{last_name}"
  end

  def notifications?
    unanswered_enquiries? || enquiries_needing_confirmation? || owners_needing_feedback? || homestays_needing_feedback? || booking_needing_confirmation? || booking_required_response? || booking_declined_by_host? || booking_accepted_by_host?
  end

  def booking_accepted_by_host?
	  booking_accepted_by_host.any?
  end

  def booking_accepted_by_host
		self.bookers.accepted_by_host
  end

  def booking_declined_by_host?
	  booking_declined_by_host.any?
  end

  def booking_declined_by_host
	  self.bookers.declined_by_host
	end

  def booking_required_response?
	  booking_required_response.any?
  end

  def booking_required_response
	  self.bookers.required_response
  end

  def unanswered_enquiries?
    unanswered_enquiries.any?
  end

  def unanswered_enquiries
    homestay.present? ? homestay.enquiries.unanswered : []
  end

  def enquiries_needing_confirmation?
    enquiries_needing_confirmation.any?
  end

  def booking_needing_confirmation?
	  booking_needing_confirmation.any?
  end

  def booking_needing_confirmation
	  homestay.blank? ? [] : homestay.bookings.needing_host_confirmation
  end

  def enquiries_needing_confirmation
    enquiries.need_confirmation
  end

  def owners_needing_feedback?
    owners_needing_feedback.present?
  end

  def owners_needing_feedback
    if homestay.present?
      homestay.enquiries.owner_accepted.need_feedback.delete_if {|e| e.feedback_for_owner.present? }
    end
  end

  def homestays_needing_feedback?
    homestays_needing_feedback.present?
  end

  def homestays_needing_feedback
    enquiries.owner_accepted.need_feedback.delete_if {|e| e.feedback_for_homestay.present? }
  end

  def pet_name
    if pets.length == 1
      pets.first.name
    else
      'your pets'
    end
  end

  def pet_names
    pets.map(&:name).to_sentence
  end

  def pet_breed
		pets.map(&:breed).to_sentence
  end

  def pet
	  self.pets.first unless self.pets.blank?
  end

  def update_average_rating
    rating = received_feedbacks.count == 0 ? 0 : received_feedbacks.sum('rating') / received_feedbacks.count
    update_attribute :average_rating, rating
  end

  def find_or_create_booking_by(enquiry=nil, homestay=nil)
	  unfinished_bookings = self.bookers.unfinished
	  booking = unfinished_bookings.blank? ? self.bookers.build : unfinished_bookings.first

		booking.enquiry = enquiry
	  booking.homestay = homestay
	  booking.bookee = homestay.user
	  booking.cost_per_night = homestay.cost_per_night

	  date_time_now = DateTime.now
	  time_now = Time.now
	  booking.check_in_date = enquiry.blank? ? date_time_now : (enquiry.check_in_date.blank? ? date_time_now : enquiry.check_in_date)
	  booking.check_in_time = enquiry.blank? ? time_now : (enquiry.check_in_time.blank? ? time_now : enquiry.check_in_time)
	  booking.check_out_date = enquiry.blank? ? date_time_now : (enquiry.check_out_date.blank? ? date_time_now : enquiry.check_out_date)
	  booking.check_out_time = enquiry.blank? ? time_now : (enquiry.check_out_time.blank? ? time_now : enquiry.check_out_time)
	  number_of_nights = (booking.check_out_date - booking.check_in_date).to_i
		booking.number_of_nights = number_of_nights <= 0 ? 1 : number_of_nights

	  booking.subtotal = booking.cost_per_night * booking.number_of_nights
	  booking.amount = booking.subtotal + booking.transaction_fee
	  booking.save!
	  booking
  end

	def find_or_create_transaction_by(booking)
		transaction = booking.transaction.blank? ? Transaction.find_or_create_by_booking_id(booking.id) : booking.transaction

		transaction.reference = "transaction_id=#{transaction.id}"
		transaction.type_code = 1 # preauth type is 1, simple transaction type is 0
		transaction.amount = booking.amount
		transaction.time_stamp = Time.now.gmtime.strftime("%Y%m%d%H%M%S")

		fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{transaction.type_code}|#{transaction.
				reference}|#{transaction.actual_amount}|#{transaction.time_stamp}"

		transaction.merchant_fingerprint = Digest::SHA1.hexdigest(fingerprint_string)

		transaction.save!
		transaction
	end

	def find_stored_card_id(selected_stored_card=nil, use_stored_card=nil)
		if selected_stored_card.blank?
			if use_stored_card.blank?
			  return nil
			elsif use_stored_card.to_s == '1' && self.cards.size >= 1
				return self.cards.first.id
			end
		else
			return selected_stored_card
		end
	end
end
