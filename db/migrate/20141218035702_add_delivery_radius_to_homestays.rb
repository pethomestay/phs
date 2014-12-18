class AddDeliveryRadiusToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :delivery_radius, :integer
  end
end
