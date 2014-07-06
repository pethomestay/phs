class AddRefundedToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :refunded, :boolean, :default => false
  end
end
