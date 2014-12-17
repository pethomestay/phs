class AddEmergencySitsToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :emergency_sits, :boolean
  end
end
