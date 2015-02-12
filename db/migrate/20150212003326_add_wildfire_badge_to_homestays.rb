class AddWildfireBadgeToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :wildfire_badge, :boolean
  end
end
