class ChangeStatusToStateForBookings < ActiveRecord::Migration
  def change
    rename_column :bookings, :status, :state
  end
end
