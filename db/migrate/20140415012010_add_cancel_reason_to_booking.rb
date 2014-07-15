class AddCancelReasonToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :cancel_reason, :string
  end
end
