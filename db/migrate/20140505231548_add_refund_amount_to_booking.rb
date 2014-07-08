class AddRefundAmountToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :refund, :float
  end
end
