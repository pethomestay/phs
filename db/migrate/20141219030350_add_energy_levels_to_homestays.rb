class AddEnergyLevelsToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :energy_levels, :text
  end
end
