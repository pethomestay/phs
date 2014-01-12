require 'pry'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :current_password, :accept_house_rules, :accept_terms

  has_one :homestay
  has_many :pets
  has_many :enquiries
  has_many :bookers, class_name: 'Booking', foreign_key: :booker_id
  has_many :bookees, class_name: 'Booking', foreign_key: :bookee_id

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
      "your pets"
    end
  end

  def pet_names
    pets.map(&:name).to_sentence
  end

  def update_average_rating
    rating = received_feedbacks.count == 0 ? 0 : received_feedbacks.sum('rating') / received_feedbacks.count
    update_attribute :average_rating, rating
  end

  def find_or_create_booking_by(params)
	  unfinished_bookings = self.bookers.unfinished
	  booking = nil
	  if unfinished_bookings.blank?
		  booking = self.bookers.create!
	  else
			return unfinished_bookings.first
	  end

	  homestay = nil

		unless params[:enquiry_id].blank?
			enquiry = Enquiry.find(params[:enquiry_id])
			booking.enquiry = enquiry
			homestay = enquiry.homestay
		end

	  homestay = Homestay.find(params[:homestay_id]) unless params[:homestay_id].blank?

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
	  booking.amount = booking.subtotal + TRANSACTION_FEE

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
		require 'digest/sha1'
		transaction.merchant_fingerprint = Digest::SHA1.hexdigest(fingerprint_string)

		transaction.save!
		transaction
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

  def self.find_for_facebook_oauth(auth, current_user)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      if current_user  #if we have a current user save
        user = current_user
      else
        user = where(email: auth.info.email).first_or_initialize
      end
      if not user.persisted? #must be a new user fill in the details
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.date_of_birth  =   Date.new(1800,01,01) #fake date
        user.address_suburb = "n/a"
        user.address_1 = "n/a"
        location_info =  auth.extra['raw_info']['location']['name'].split(" ")
        user.address_city = location_info[0].gsub(/,/,'')
        state = location_info[1].gsub(/,/,'')       #note we don't have a state for user????
        user.address_country = location_info[2]
        graph = Koala::Facebook::API.new(auth['credentials']['token'])
        age_info = graph.get_object("me", :fields=>"age_range")
        user.age_range_min = age_info['age_range']['min']
        user.age_range_max = age_info['age_range']['max']
      end
      if user.provider.nil?
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
end
