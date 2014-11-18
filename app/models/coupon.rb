class Coupon < ActiveRecord::Base
  attr_accessible :code, :credit_referrer_amount, :discount_amount, :booking_id, :referrer_id, :used_by_id, :valid_from, :valid_to
  belongs_to :booking
  belongs_to :used_by, class_name: "User", foreign_key: :used_by_id 
  belongs_to :referred_by, class_name: "User", foreign_key: :referrer_id
  validates_uniqueness_of :used_by_id

  DEFAULT_DISCOUNT_AMOUNT = 10
  DEFAULT_CREDIT_REFERRER_AMOUNT = 5

  def used?
    return self.booking.present?
  end

  def unused?
    return self.booking.nil?
  end

end
