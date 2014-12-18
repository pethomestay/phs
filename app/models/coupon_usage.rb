class CouponUsage < ActiveRecord::Base
  belongs_to :user
  belongs_to :coupon
  belongs_to :booking
  attr_accessible :coupon_status, :user_id, :coupon_id
  scope :unused, -> { where("booking_id IS NULL")}
  after_create :increment_counter

  private

  def increment_counter
    self.coupon.increment!(:users_count)
  end
end
