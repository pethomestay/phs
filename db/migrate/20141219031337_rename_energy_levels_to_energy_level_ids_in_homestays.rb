class RenameEnergyLevelsToEnergyLevelIdsInHomestays < ActiveRecord::Migration
  def change
    rename_column :homestays, :energy_levels, :energy_level_ids
  end
end
