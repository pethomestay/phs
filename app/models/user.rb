require 'digest/sha1'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :current_password, :accept_house_rules, :accept_terms

  attr_accessible :first_name, :last_name, :email, :mobile_number, :password,
    :accept_house_rules, :accept_terms, :date_of_birth, :address_1, :address_2,
    :address_suburb, :address_city, :address_postcode, :address_country,
    :password_confirmation, :braintree_customer_id, :coupon_code, :opt_out_sms,
    :responsiveness_score, :active, :hex, :provider, :uid, :age_range_min, :age_range_max

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
  phony_normalize :mobile_number, :default_country_code => 'AU'

  validates :accept_house_rules, :acceptance => true
  validates :accept_terms, :acceptance => true
  validates_uniqueness_of :hex#, :allow_blank => true

  after_create :generate_referral_code
  before_save  :generate_hex

  scope :active, where(active: true)
  scope :last_five, order('created_at DESC').limit(5)

  # Creates the coupon code that users can share with others: First four letters of first name + first letter of last name +
  # custom_discount = nil, custom_credit = nil
  def generate_referral_code(force = false, args = {})
    return if !force && owned_coupons.any?

    owned_coupons.create ReferralCodeGenerator.new(self, args).generate
  end

  # Created a unique hex which will be used for matching recommendations
  def generate_hex
    return if self.hex.present?

    hex_value = SecureRandom.hex(10)
    
    while User.where(hex: hex_value).present?
      hex_value = SecureRandom.hex(10)
    end

    self.hex = hex_value
  end

  # Returns the dollar amount of money earned from owned coupons
  def coupon_credits_earned
    owned_coupons.includes(:bookings).inject(0) do |total, coupon|
      total += coupon.credit_referrer_amount.to_f * coupon.bookings.length
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def update_average_rating
    update_attribute :average_rating, received_feedbacks.average_rating
  end

  def unlink_from_facebook
    update_attributes(uid: nil, provider: nil)
  end

  def needs_password?
    provider.blank?
  end

  def admin?
    admin || Rails.env.staging? || Rails.env.development?
  end

  # Expect two params, from & to, both of which are Date objects
  def is_available?(opts = {})
    return false if opts.blank?

    unavailable_dates.where('date >= ? AND date <= ?', opts[:from], opts[:to]).blank?
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

  def store_responsiveness_rate
    update_column(:responsiveness_rate, response_rate_in_percent)
    responsiveness_rate
  end
end
