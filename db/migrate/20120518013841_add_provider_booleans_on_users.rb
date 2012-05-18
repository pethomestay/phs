class AddProviderBooleansOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :wants_to_be_sitter, :boolean
    add_column :users, :wants_to_be_hotel,  :boolean
  end
end
