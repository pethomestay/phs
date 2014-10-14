class AddEnergyLevelToPets < ActiveRecord::Migration
  def change
    add_column :pets, :energy_level, :integer
  end
end
