require 'digest/sha1'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :current_password, :accept_house_rules, :accept_terms

  attr_accessible :first_name, :last_name, :email, :mobile_number, :password,
    :accept_house_rules, :accept_terms, :date_of_birth, :address_1, :address_2,
    :address_suburb, :address_city, :address_postcode, :address_country,
    :password_confirmation, :braintree_customer_id, :coupon_code, :opt_out_sms,
    :responsiveness_score, :active, :hex

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
  has_one  :account
  has_many :payments
  has_many :coupon_usages
  has_many :used_coupons, through: :coupon_usages, source: :coupon
  has_many :owned_coupons, class_name: "Coupon", foreign_key: :user_id
  has_many :coupon_payouts, dependent: :destroy
  has_many :recommendations, dependent: :destroy

  has_many :given_feedbacks, class_name: 'Feedback'
  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'subject_id'

  has_many :unavailable_dates

  has_attachment :profile_photo, accept: [:jpg, :png, :bmp, :gif]

  validates_presence_of :first_name, :last_name, :email
  # validates :mobile_number, presence: true, if: 'provider.nil?'
  phony_normalize :mobile_number, :default_country_code => 'AU'
  # validates_plausible_phone :mobile_number

  validates :accept_house_rules, :acceptance => true
  validates :accept_terms, :acceptance => true
  validates_acceptance_of :accept_house_rules, on: :create
  validates_acceptance_of :accept_terms, on: :create
  validates_uniqueness_of :hex, :allow_blank => true

  after_create :generate_referral_code
  after_save   :generate_hex

  scope :active, where(active: true)
  scope :last_five, order('created_at DESC').limit(5)

  # Creates the coupon code that users can share with others: First four letters of first name + first letter of last name +
  # custom_discount = nil, custom_credit = nil
  def generate_referral_code(force = false, args = {})
    return if !force && self.owned_coupons.any?
    if args[:custom_code]
      final_code = args[:custom_code].upcase
    else
      suggested_code = self.first_name.gsub(/[^a-z]/i, '').slice(0..3).to_s + self.last_name.gsub(/[^a-z]/i, '').slice(0).to_s
      suggested_code += "X"*(5 - suggested_code.length) if suggested_code.length < 5
      non_unique = Coupon.where("code LIKE ?", "%#{suggested_code.upcase}%").count
      unique_num = non_unique > 0 ? non_unique.to_s : ""
      final_code = unique_num + suggested_code + Coupon::DEFAULT_DISCOUNT_AMOUNT.to_s
    end
    discount_amount = args[:custom_discount] || Coupon::DEFAULT_DISCOUNT_AMOUNT
    referrer_amount = args[:custom_credit] || Coupon::DEFAULT_CREDIT_REFERRER_AMOUNT
    self.owned_coupons.create!(:code => final_code.upcase, :discount_amount => discount_amount, :credit_referrer_amount => referrer_amount, :valid_from => Date.today())
    return true
  end

  # Created a unique hex which will be used for matching recommendations
  def generate_hex
    return unless self.hex.nil?
    hex = SecureRandom.hex(10)
    self.hex = hex
    while !self.valid?
      hex = SecureRandom.hex(10)
      self.hex = hex
    end
    self.update_column(:hex, hex)
  end

  # Returns the dollar amount of money earned from owned coupons
  def coupon_credits_earned
    total = 0
    self.owned_coupons.each do |coupon|
      total += coupon.credit_referrer_amount.to_f * coupon.bookings.count
    end
    total
  end

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
      @bookings = Booking.where(:state=>:host_requested_cancellation)
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

  def validate_code?(code)
    code.upcase!
    return false if self.used_coupons.any?
    coupon = Coupon.valid.find_by_code(code)
    return false if coupon.nil?
    return false if coupon.owner == self
    return false if coupon.coupon_limit.present? && coupon.users_count >= coupon.coupon_limit
    return false if coupon.valid_to.present? && Time.now > coupon.valid_to
    return false if coupon.admin_mass_code
    CouponUsage.create(:user_id => self.id, :coupon_id => coupon.id)
    return true
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
    rating = received_feedbacks.count == 0 ? 0 : (received_feedbacks.sum('rating') / received_feedbacks.count).ceil
    update_attribute :average_rating, rating
  end

  def find_or_create_booking_by(enquiry=nil, homestay=nil)
    homestay = enquiry.homestay if homestay.nil?
    booking = enquiry.booking || Booking.new
    # unfinished_bookings = self.bookers.unfinished.where(:homestay_id=>homestay_id).all()
    # booking = unfinished_bookings.blank? ? self.bookers.build : unfinished_bookings.first

    booking.enquiry = enquiry
    booking.homestay = homestay
    booking.bookee = homestay.user
    booking.cost_per_night = homestay.cost_per_night
    booking.booker = enquiry.user

    date_time_now = DateTime.now
    time_now = Time.now
    if booking.check_in_date.blank? or booking.check_in_time.blank? or booking.check_out_time.blank? or booking.check_out_date.blank? #set the date/time  if not already set
      booking.check_in_date = enquiry.blank? ? date_time_now : (enquiry.check_in_date.blank? ? date_time_now : enquiry.check_in_date)
      booking.check_in_time = enquiry.blank? ? time_now : (enquiry.check_in_time.blank? ? time_now : enquiry.check_in_time)
      booking.check_out_date = enquiry.blank? ? date_time_now : (enquiry.check_out_date.blank? ? date_time_now : enquiry.check_out_date)
      booking.check_out_time = enquiry.blank? ? time_now : (enquiry.check_out_time.blank? ? time_now : enquiry.check_out_time)
    end
    number_of_nights = (booking.check_out_date - booking.check_in_date).to_i
    booking.number_of_nights = number_of_nights <= 0 ? 1 : number_of_nights

    booking.subtotal = booking.cost_per_night * booking.number_of_nights
    booking.amount = booking.calculate_amount
    booking.host_accepted = nil
    booking.owner_accepted = nil
    booking.for_charity = homestay.for_charity
    booking.save!
    booking.mailbox.update_attribute(:booking_id, booking.id)
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
    #current_password = params.delete(:current_password)

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
    #new_email = "darmou+#{clean_email.split("@").first}_#{self.id.to_s}@tapmint.com" #
    new_email = "xuebing@pethomestay.com"
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

  def admin?
    return self.admin || Rails.env == "staging" || Rails.env == "development"
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  # Depreciated
  def booking_info_between(start_date, end_date)
    booking_info = self.unavailable_dates_info(start_date, end_date)
    booking_info += self.booked_dates_info(start_date, end_date)
    available_dates = (start_date..end_date).to_a - (booking_info.map{ |info| info[:start].to_date }).uniq
    booking_info += available_dates.collect do |date|
      { title: "Available", start: date.strftime("%Y-%m-%d") }
    end
    booking_info
  end

  # Depreciated
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

  def booked_dates_between(start_date, end_date)
    bookings = self.bookees.with_state(:finished_host_accepted).where("check_in_date between ? and ? or (check_in_date < ? and check_out_date > ?)", start_date, end_date, start_date, start_date)
    bookings.collect do |booking|
      if booking.check_out_date == booking.check_in_date
        [booking.check_in_date]
      else
        booking_start = booking.check_in_date < start_date ? start_date : booking.check_in_date
        booking_end = booking.check_out_date > end_date ? end_date : booking.check_out_date - 1.day
        (booking_start..booking_end).to_a
      end
    end.flatten.compact.uniq
  end

  # Depreciated
  def booked_dates_info(start_date, end_date)
    self.booked_dates_between(start_date, end_date).collect do|date|
      { title: "Booked", start: date.strftime("%Y-%m-%d") }
    end
  end

  #returns user's booked, unavailable dates
  def unavailable_dates_between(checkin_date, checkout_date)
    end_date = checkin_date == checkout_date ? checkout_date : checkout_date - 1.day
    booked_dates = self.booked_dates_between(checkin_date, end_date)
    unavailable_dates = self.unavailable_dates.between(checkin_date, end_date).map(&:date)
    (booked_dates + unavailable_dates).uniq
  end

  def unavailable_dates_after(start_date)
    bookings = self.bookees.with_state(:finished_host_accepted).where("check_in_date >= ? or (check_in_date < ? and check_out_date > ?)", start_date, start_date, start_date)
    unavailable_dates = bookings.collect do |booking|
      if booking.check_out_date == booking.check_in_date
        [booking.check_in_date]
      else
        booking_start = booking.check_in_date < start_date ? start_date : booking.check_in_date
        booking_end = booking.check_out_date - 1.day
        (booking_start..booking_end).to_a
      end
    end.flatten.compact.uniq
    unavailable_dates += self.unavailable_dates.where("date >= ?", start_date).map(&:date)
    unavailable_dates.uniq
  end

  # Expect two params, from & to, both of which are Date objects
  def is_available?(opts)
    if self.unavailable_dates.select(:date)
       .where('date >= ? AND date <= ?', opts[:from], opts[:to]).any?
      false # Unavailable
    else
      true  # Available
    end
  end

  # New response_rate
  # True or False if Message in Mailbox is responded within 24 hrs
  # Ideally each mailbox has a score, then aggregate mailbox scores into User
  # For the time being, use existing response_rate_in_percent
  def new_response_rate_in_percent

  end

  # Original response_rate
  def response_rate_in_percent(new_version = false)
    if self.admin? && new_version
      self.new_response_rate_in_percent
    else
      # Fetch all host_mailboxes created from 30 days ago to 24 hours ago. Return nil if none found.
      # Write down total count of fetched host mailboxes.
      # For each mailbox, try to find the oldest response from current user (as a Host). Ignore this
      # mailbox if none found.
      # Check if response time is less than 24 hours. Count if it is.
      mailboxes = self.host_mailboxes.where(created_at: 10000.days.ago..24.hours.ago)
      return nil if mailboxes.blank? # Current user (as a Host) has not received any message
      total = mailboxes.count
      count = 0
      mailboxes.each do |mailbox|
        host_response = mailbox.messages.where(user_id: self.id).order('created_at ASC').limit(1)[0]
        if host_response.present? # If there exists a response from current user (as a Host)
          time_diff = host_response.created_at - mailbox.created_at
          count += 1 if time_diff <= 24.hours
        end
      end
      # calculate response rate in PERCENTAGE
      score = (count * 100.0 / total).round 0
      return nil if score == 0 # Hide host responsiveness if the score is 0
      score
    end
  end

  def mobile_num_legal?
    return if self.mobile_number.blank?
    m = self.mobile_number.gsub(/[^0-9]/, "")
    case m.length
    when 10 # 0416 123 456
      true
    when 11 # 61 416 291 496
      true
    when 13 # 0061 416 123 456
      true
    else
      false
    end
  end
end
