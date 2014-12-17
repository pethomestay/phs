class CouponPayout < ActiveRecord::Base
  belongs_to :user
  attr_accessible :paid, :payment_amount
  scope :unpaid, -> {where("paid IS NOT true")}
  scope :paid,   -> {where("paid IS true")}
end
