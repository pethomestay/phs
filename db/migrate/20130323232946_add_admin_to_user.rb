class AddAdminToUser < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean, default: false
    execute 'update users set admin = false;'
    execute "update users set admin = true where email in ('adam.boas@gmail.com', 'tom@pethomestay.com');"
    add_index :users, :admin
  end

  def down
    remove_index :users, :admin
    remove_column :users, :admin
  end
end
