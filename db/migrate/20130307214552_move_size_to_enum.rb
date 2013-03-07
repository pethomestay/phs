class MoveSizeToEnum < ActiveRecord::Migration
  def up
    add_column :pets, :size_id, :integer
    execute "update pets set size_id = 1 where size = 'small'"
    execute "update pets set size_id = 2 where size = 'medium'"
    execute "update pets set size_id = 3 where size = 'large'"
    execute "update pets set size_id = 4 where size = 'giant'"
    remove_column :pets, :size
  end

  def down
    add_column :pets, :size, :string
    execute "update pets set size = 'small'  where   size_id = 1"
    execute "update pets set size = 'medium' where size_id = 2"
    execute "update pets set size = 'large'   where   size_id = 3"
    execute "update pets set size = 'giant' where   size_id = 4"
    remove_column :pets, :size_id
  end
end
