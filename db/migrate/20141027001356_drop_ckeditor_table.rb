class DropCkeditorTable < ActiveRecord::Migration
  def up
    drop_table :ckeditor_assets
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
