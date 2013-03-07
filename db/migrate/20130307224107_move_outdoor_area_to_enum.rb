class MoveOutdoorAreaToEnum < ActiveRecord::Migration
  def up
    add_column :homestays, :outdoor_area_id, :integer
    add_index :homestays, :outdoor_area_id
    execute "update homestays set outdoor_area_id = 1 where outdoor_area = 'small'"
    execute "update homestays set outdoor_area_id = 2 where outdoor_area = 'medium'"
    execute "update homestays set outdoor_area_id = 3 where outdoor_area = 'large'"
    remove_column :homestays, :outdoor_area
  end

  def down
    add_column :homestays, :outdoor_area, :string
    execute "update homestays set outdoor_area = 'small'  where   outdoor_area_id = 1"
    execute "update homestays set outdoor_area = 'medium' where outdoor_area_id = 2"
    execute "update homestays set outdoor_area = 'large'   where   outdoor_area_id = 3"
    remove_index :homestays, :outdoor_area_id
    remove_column :homestays, :outdoor_area_id
  end
end
