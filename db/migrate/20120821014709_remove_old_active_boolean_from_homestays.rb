class RemoveOldActiveBooleanFromHomestays < ActiveRecord::Migration
  def up
    remove_column :homestays, :active
  end

  def down
    add_column :homestays, :active, :boolean
  end
end
