class AddCountryToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :address_country, :string
  end
end
