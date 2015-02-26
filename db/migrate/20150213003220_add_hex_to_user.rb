class AddHexToUser < ActiveRecord::Migration
  def change
    add_column :users, :hex, :string
  end
end
