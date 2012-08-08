class AddPropertyOptionsToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :outdoor_area, :string
    add_column :homestays, :property_type, :string
  end
end
