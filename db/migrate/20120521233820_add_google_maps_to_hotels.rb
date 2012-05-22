class AddGoogleMapsToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :latitude,  :float
    add_column :hotels, :longitude, :float
  end
end
