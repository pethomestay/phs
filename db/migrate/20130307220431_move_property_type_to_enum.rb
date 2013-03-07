class MovePropertyTypeToEnum < ActiveRecord::Migration
  def up
    add_column :homestays, :property_type_id, :integer
    add_index :homestays, :property_type_id
    execute "update homestays set property_type_id = 1 where property_type = 'house'"
    execute "update homestays set property_type_id = 2 where property_type = 'apartment'"
    execute "update homestays set property_type_id = 3 where property_type = 'farm'"
    execute "update homestays set property_type_id = 4 where property_type = 'townhouse'"
    execute "update homestays set property_type_id = 5 where property_type = 'unit'"
    remove_column :homestays, :property_type
  end

  def down
    add_column :homestays, :property_type, :string
    execute "update homestays set property_type = 'house'  where   property_type_id = 1"
    execute "update homestays set property_type = 'apartment' where property_type_id = 2"
    execute "update homestays set property_type = 'farm'   where   property_type_id = 3"
    execute "update homestays set property_type = 'townhouse' where   property_type_id = 4"
    execute "update homestays set property_type = 'unit' where   property_type_id = 5"
    remove_index :homestays, :property_type_id
    remove_column :homestays, :property_type_id
  end
end
