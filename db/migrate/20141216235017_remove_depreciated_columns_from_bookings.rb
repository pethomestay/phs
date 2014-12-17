class RemoveDepreciatedColumnsFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :pet_name
    remove_column :bookings, :guest_name
  end

  def down
    add_column :bookings, :guest_name, :string
    add_column :bookings, :pet_name, :string
  end
end
