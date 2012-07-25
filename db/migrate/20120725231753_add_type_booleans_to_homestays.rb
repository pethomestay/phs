class AddTypeBooleansToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :is_homestay, :boolean, default: false
    add_column :homestays, :is_sitter, :boolean, default: false
    add_column :homestays, :is_services, :boolean, default: false
  end
end
