class RemoveTypingBooleansFromHomestays < ActiveRecord::Migration
  def up
    remove_column :homestays, :is_sitter
    remove_column :homestays, :is_services
    remove_column :homestays, :is_homestay
  end

  def down
    add_column :homestays, :is_homestay, :boolean, default: false
    add_column :homestays, :is_services, :boolean, default: false
    add_column :homestays, :is_sitter, :boolean, default: false
  end
end
