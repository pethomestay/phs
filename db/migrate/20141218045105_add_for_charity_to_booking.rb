class AddForCharityToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :for_charity, :boolean
  end
end
