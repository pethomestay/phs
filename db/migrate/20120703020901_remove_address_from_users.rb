class RemoveAddressFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :address_1
    remove_column :users, :address_2
    remove_column :users, :address_suburb
    remove_column :users, :address_city
    remove_column :users, :address_postcode
    remove_column :users, :latitude
    remove_column :users, :longitude
    remove_column :users, :address_country
  end

  def down
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :address_suburb, :string
    add_column :users, :address_city, :string
    add_column :users, :address_postcode, :string
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
    add_column :users, :address_country, :string
  end
end
