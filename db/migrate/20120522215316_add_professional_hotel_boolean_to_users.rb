class AddProfessionalHotelBooleanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wants_to_be_professional_hotel, :boolean
  end
end
