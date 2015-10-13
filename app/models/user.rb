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
  has_many :devices, dependent: :destroy

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

  # Finds a matching device for the user, or creates a new one.
  # @api public
  # @param device_params [Hash] The device params.
  # @option device_params [String] :name The device name.
  # @option device_params [String] :token The device token.
  # @return [Device] The matching device.
  def record_device(device_params)
    return if device_params.blank?
    device_params.to_options!
    device = devices.where(token: device_params[:token]).first
    if device.present?
      device.update_attribute(:active, true) if !device.active?
      device
    else
      devices.create(
        name: device_params[:name],
        token: device_params[:token]
      )
    end
  end

  # Updates the user's OAuth details.
  # @api public
  # @note The current schema only allows one OAuth provider per user.
  # @param oauth_params [Hash] The OAuth params.
  # @option oauth_params [String] :provider The OAuth provider.
  # @option oauth_params [String] :token The OAuth token.
  # @return [User] The user.
  def record_oauth(oauth_params)
    return if oauth_params.blank?
    oauth_params.to_options!
    update_attributes(
      provider: oauth_params[:provider],
      uid: oauth_params[:token]
    )
    self
  end

  # Creates the coupon code that users can share with others: First four letters of first name + first letter of last name +
  # custom_discount = nil, custom_credit = nil
  #
  # @params
  #   force [Boolean]
  #   args [Hash]
  #    custom_discount [Integer]
  #    custom_credit [Integer]
  #    custom_code [String]
  # @api public
  # @return [Coupon]
  def generate_referral_code(force = false, args = {})
    return if !force && owned_coupons.any?

    owned_coupons.create ReferralCodeGenerator.new(self, args).generate
  end

  # Created a unique hex which will be used for matching recommendations
  #
  # @api public
  # @return [String]
  def generate_hex
    return if self.hex.present?

    hex_value = SecureRandom.hex(10)
    
    while User.where(hex: hex_value).present?
      hex_value = SecureRandom.hex(10)
    end

    self.hex = hex_value
  end

  # Returns the dollar amount of money earned from owned coupons
  #
  # @api public
  # @return [Float]
  def coupon_credits_earned
    owned_coupons.includes(:bookings).inject(0) do |total, coupon|
      total += coupon.credit_referrer_amount.to_f * coupon.bookings.length
    end
  end

  # Return user name
  #
  # @api public
  # @return [String]
  def name
    "#{first_name} #{last_name}"
  end

  # Update Average rating for user
  #
  # @api public
  # @return [Boolean]
  def update_average_rating
    update_attribute :average_rating, received_feedbacks.average_rating
  end

  # Unlink account from facebook
  #
  # @api public
  # @return [Boolean]
  def unlink_from_facebook
    update_attributes(uid: nil, provider: nil)
  end

  # Check if user needs password
  #
  # @api public
  # @return [Boolean]
  def needs_password?
    provider.blank?
  end

  # Check if user is admin
  #
  # @api public
  # @return [Boolean]
  def admin?
    admin || Rails.env.staging? || Rails.env.development?
  end

  # Expect two params, from & to, both of which are Date objects
  # Check if user is available
  #
  # @api public
  # @return [Boolean]
  def is_available?(opts = {})
    return false if opts.blank?

    Scheduler.new(self, start_date: opts[:from], end_date: opts[:to]).unavailable_dates_info.blank?
  end

  # Original response_rate
  # 
  # @params
  #   new_version [Boolean]
  # @api public
  # @return [Float]
  def response_rate_in_percent(new_version = false)
    if self.admin? && new_version
      #self.new_response_rate_in_percent
    else
      return nil if monitored_mailboxes.blank?

      calculate_score(monitored_response_count, monitored_mailboxes.count)
    end
  end

  # Store responsiveness_rate
  #
  # @api public
  # @return [Float]
  def store_responsiveness_rate
    update_column(:responsiveness_rate, response_rate_in_percent)
    responsiveness_rate
  end

  private

  # Helper method to calculate score
  #
  # @api private
  # @return [Float]
  def calculate_score(count, total)
    return nil if count == 0

    (count * 100.0 / total).round 0
  end

  # Return monitored mailboxes
  #
  # @api private
  # @return [Mailbox]
  def monitored_mailboxes
    @monitored_mailboxes ||= host_mailboxes.where(created_at: 10000.days.ago..24.hours.ago).includes(:messages)
  end

  # Return response count
  #
  # @api private
  # @return [Integer]
  def monitored_response_count
    monitored_mailboxes.includes(:messages).select do |mailbox|
      host_response = mailbox.messages.where(user_id: self.id).order('created_at ASC').limit(1)[0]

      host_response && (host_response.created_at - mailbox.created_at) <= 24.hours
    end.length
  end

end
