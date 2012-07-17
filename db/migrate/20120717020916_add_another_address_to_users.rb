class AddAnotherAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :address_suburb, :string
    add_column :users, :address_city, :string
    add_column :users, :address_postcode, :string
    add_column :users, :address_country, :string
  end
end
