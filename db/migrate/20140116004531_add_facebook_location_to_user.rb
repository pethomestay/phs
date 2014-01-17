class AddFacebookLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_location, :string
  end
end
