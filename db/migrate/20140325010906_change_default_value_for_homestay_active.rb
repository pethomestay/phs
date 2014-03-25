class ChangeDefaultValueForHomestayActive < ActiveRecord::Migration
  def change
    change_column :homestays, :active, :boolean, :default => false
  end


end
