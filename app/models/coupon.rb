class Coupon < ActiveRecord::Base
  attr_accessible :code, :credit_referrer_amount, :discount_amount, :user_id, :valid_from, :valid_to
  has_many :users, through: :coupon_usages, foreign_key: :user_id
  has_many :coupon_usages
  has_many :bookings, through: :coupon_usages, foreign_key: :booking_id
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  validates :code, :uniqueness => { :allow_blank => false, :allow_nil => false, :case_sensitive => false }
  scope :valid, -> {where("valid_to IS NULL or valid_to > '#{Time.now}'")}
  scope :invalid, -> {where("valid_to <= '#{Time.now}'")}
  DEFAULT_DISCOUNT_AMOUNT = 10
  DEFAULT_CREDIT_REFERRER_AMOUNT = 5

  def used?
    return self.booking.present?
  end

  def unused?
    return self.booking.nil?
  end
end
