class Coupon < ActiveRecord::Base
  attr_accessible :code, :credit_referrer_amount, :discount_amount, :payment_id, :referrer_id, :used_by_id, :valid_from, :valid_to
  belongs_to :payment
  belongs_to :used_by, class_name: "User", foreign_key: :used_by_id 
  belongs_to :referred_id, class_name: "User", foreign_key: :referred_id
  validates_uniqueness_of :used_by_id

  DEFAULT_DISCOUNT_AMOUNT = 10
  DEFAULT_CREDIT_REFERRER_AMOUNT = 5

end
