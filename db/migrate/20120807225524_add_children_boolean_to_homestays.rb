class AddChildrenBooleanToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :children_present, :boolean, default: false
  end
end
