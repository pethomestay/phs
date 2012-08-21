class AddActiveBooleanToHomestaysAndUsers < ActiveRecord::Migration
  def change
    add_column :homestays,  :active, :boolean, default: true
    add_column :users,      :active, :boolean, default: true
  end
end
