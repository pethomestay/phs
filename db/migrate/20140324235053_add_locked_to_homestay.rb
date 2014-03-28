class AddLockedToHomestay < ActiveRecord::Migration
  def change
    add_column :homestays, :locked, :boolean, :default => true
  end
end
