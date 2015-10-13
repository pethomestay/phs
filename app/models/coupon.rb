class Coupon < ActiveRecord::Base
  attr_accessible :code, :credit_referrer_amount, :discount_amount, :user_id, :valid_from, :valid_to, :coupon_limit, :users_count, :discount_is_percentage, :admin_mass_code
  has_many :users, through: :coupon_usages, foreign_key: :user_id
  has_many :coupon_usages
  has_many :bookings, through: :coupon_usages, foreign_key: :booking_id
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  validates :code, :uniqueness => { :allow_blank => false, :allow_nil => false, :case_sensitive => false }
  validates :discount_amount, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 100}
  validate :within_coupon_limit, on: :create
  scope :valid, -> {where("valid_to IS NULL or valid_to > ?", Time.now).where("coupon_limit >= users_count or coupon_limit IS NULL")}
  scope :invalid, -> {where("valid_to <= ? or coupon_limit < users_count", Time.now)}
  DEFAULT_DISCOUNT_AMOUNT = 10
  DEFAULT_CREDIT_REFERRER_AMOUNT = 5

  # Checks if coupon is used
  #
  # @api public
  # @return [Boolean]
  def used?
    bookings.any?
  end
  
  # Checks if coupon is valid for user
  #
  # @params
  #   user [User]
  # @api public
  # @return [Boolean]
  def valid_for? user
    return false if user.nil?
    return false if user.used_coupons.any?
    return false if exceeded_coupon_limit?
    return false if valid_to.present? && Time.now > valid_to
    return false if admin_mass_code

    true
  end

  private

  # Validation for coupon limit
  #
  # @api private
  # @return [ActiveModel::Errors]
  def within_coupon_limit
    if exceeded_coupon_limit?
      errors.add(:coupon_limit, "The coupon has already been used")
    end
  end

  # Check coupon limit
  #
  # @api private
  # @return [Boolean]
  def exceeded_coupon_limit?
    coupon_limit.present? && (users_count >= coupon_limit)
  end

end
