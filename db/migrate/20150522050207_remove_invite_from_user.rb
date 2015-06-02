class RemoveInviteFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :invite
  end

  def down
    add_column :users, :invite, :text
  end
end
