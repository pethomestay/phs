class AddInvitesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite, :text
  end
end
