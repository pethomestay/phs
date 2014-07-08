class AddCancelDateToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :cancel_date, :date
  end
end
