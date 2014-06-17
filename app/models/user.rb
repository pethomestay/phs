require 'digest/sha1'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

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
  has_many :favourites
  has_many :homestays, through: :favourites, dependent: :destroy
  has_one :account

  has_many :given_feedbacks, class_name: 'Feedback'
  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'subject_id'

  has_many :unavailable_dates

  validates_presence_of :first_name, :last_name, :email, :mobile_number

  validates :accept_house_rules, :acceptance => true
  validates :accept_terms, :acceptance => true
  validates_acceptance_of :accept_house_rules, on: :create
  validates_acceptance_of :accept_terms, on: :create

  scope :active, where(active: true)
  scope :last_five, order('created_at DESC').limit(5)

  blogs

  def name
    "#{first_name} #{last_name}"
  end

  def notifications?
    inactive_homestay? || unanswered_enquiries? || enquiries_needing_confirmation? || owners_needing_feedback? || homestays_needing_feedback? || booking_needing_confirmation? || booking_required_response? || booking_declined_by_host? || booking_accepted_by_host? || booking_host_request_cancellation?
  end

  def inactive_homestay?
    if homestay.present?
      return !homestay.active?
    else
      return false
    end
  end

  def booking_host_request_cancellation?
    if self.admin?
      @bookings = Booking.find_all_by_status(HOST_HAS_REQUESTED_CANCELLATION)
      return @bookings.length > 0
    end
    return false
  end

  def locked_homestay?
    if homestay.present?
      return homestay.locked?
    else
      return false
    end
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
      "your pets"
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
	  booking.amount = booking.calculate_amount
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

  def unlink_from_facebook
    update_column(:uid, nil)
    update_column(:provider, nil)
  end

  def needs_password?
    provider.blank?
  end

  def update_without_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update_attributes(params, *options)

    clean_up_passwords
    result
  end

  def complete_address
		"#{self.address_1} #{self.address_suburb}, #{self.address_city}, #{self.address_country}."
  end

  def sanitise
    clean_email = self.email
    if clean_email.include? "<" #in the form of Joe Blogs <joe.blogs@company.com>
      start_str = "<"
      end_str = ">"
      clean_email = clean_email[/#{start_str}(.*?)#{end_str}/m, 1] #extract out the email part
    end
    new_email = "darmou+#{clean_email.split("@").first}_#{self.id.to_s}@tapmint.com" #
    self.email = new_email
    self.password = "password"
    self.password_confirmation = "password"
    self.save!
    self.confirm!
    self.save!
  end


  def self.find_for_facebook_oauth(auth, current_user)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      graph = Koala::Facebook::API.new(auth.credentials.token)
      me = graph.get_object("me")
      if current_user  #if we have a current user save
        user = current_user
      else
        user = where(email: me["email"]).first_or_initialize
      end
      if user.mobile_number.blank?
        user.mobile_number = "n/a"
      end
      if not user.persisted? #must be a new user fill in the details
        user.email = me["email"]
        user.password = Devise.friendly_token[0,20]
        user.first_name = me["first_name"]
        user.last_name = me["last_name"]
        user.mobile_number = "n/a"
        permissions = graph.get_connections('me','permissions')
        if permissions[0]['user_location'] == 1
          location_info =  me["location"]
          if location_info
            user.facebook_location = location_info['name']
          end
        end
        age_info = graph.get_object("me", :fields=>"age_range")
        if age_info
          user.age_range_min = age_info['age_range']['min']
          user.age_range_max = age_info['age_range']['max']
        end
      end
      if user.provider.nil?
        user.skip_confirmation! # dont' need to confirm if this is a Facebook user
        user.provider = auth.provider
        user.uid = auth.uid
        user.save!
      end
      return user
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def booking_info_between(start_date, end_date)
    booking_info = self.unavailable_dates_info(start_date, end_date)
    booking_info += self.booked_dates_info(start_date, end_date)
    available_dates = (start_date..end_date).to_a - (booking_info.map{ |info| info[:start].to_date }).uniq
    booking_info += available_dates.collect do |date|
      { title: "Available", start: date.strftime("%Y-%m-%d") }
    end
    booking_info
  end

  def unavailable_dates_info(start_date, end_date)
    unavailable_dates = self.unavailable_dates.between(start_date, end_date)
    unavailable_dates.collect do |unavailable_date|
      {
        id: unavailable_date.id,
        title: "Unavailable",
        start: unavailable_date.date.strftime("%Y-%m-%d")
      }
    end
  end

  #TODO change bookings query 
  def booked_dates_between(start_date, end_date)
    bookings = self.bookees.accepted_by_host.where("check_in_date in (?) or check_out_date in (?)", (start_date..end_date).to_a, (start_date..end_date).to_a)
    bookings.collect do |booking| 
      if booking.check_out_date == booking.check_in_date && booking.check_in_date.between?(start_date, end_date)
        [booking.check_in_date]
      else
        booking_start = booking.check_in_date < start_date ? start_date : booking.check_in_date
        booking_end = booking.check_out_date > end_date ? end_date : booking.check_out_date - 1.day
        (booking_start..booking_end).to_a
      end
    end.flatten.compact.uniq
  end

  def booked_dates_info(start_date, end_date)
    self.booked_dates_between(start_date, end_date).collect do|date|
      { title: "Booked", start: date.strftime("%Y-%m-%d") }
    end
  end

  def update_calendar
    self.update_attribute(:calendar_updated_at, Date.today)
  end

end
