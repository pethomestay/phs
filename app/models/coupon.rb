class Coupon < ActiveRecord::Base
  attr_accessible :code, :credit_referrer_amount, :discount_amount, :user_id, :valid_from, :valid_to, :coupon_limit, :users_count, :discount_is_percentage, :admin_mass_code
  has_many :users, through: :coupon_usages, foreign_key: :user_id
  has_many :coupon_usages
  has_many :bookings, through: :coupon_usages, foreign_key: :booking_id
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  validates :code, :uniqueness => { :allow_blank => false, :allow_nil => false, :case_sensitive => false }
  validates :discount_amount, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 100}
  validate :within_coupon_limit, on: :create
  scope :valid, -> {where("valid_to IS NULL or valid_to > '#{Time.now}'").where("coupon_limit >= users_count or coupon_limit IS NULL")}
  scope :invalid, -> {where("valid_to <= '#{Time.now}' or coupon_limit < users_count ")}
  DEFAULT_DISCOUNT_AMOUNT = 10
  DEFAULT_CREDIT_REFERRER_AMOUNT = 5

  def used?
    return self.bookings.any?
  end

  def unused?
    return self.booking.nil?
  end

  def within_coupon_limit
    if self.coupon_limit.present? && self.users_count >= self.coupon_limit
      errors.add(:coupon_limit, "The coupon has already been used")
    end
  end

end
