class ChangePaymentIdToBookingIdOnCoupon < ActiveRecord::Migration
  def change
    rename_column :coupons, :payment_id, :booking_id
  end
end
