class AddAddressToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :address_1,         :string
    add_column :hotels, :address_2,         :string
    add_column :hotels, :address_suburb,    :string
    add_column :hotels, :address_city,      :string
    add_column :hotels, :address_postcode,  :string
  end
end
