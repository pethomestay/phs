class AddProfilePhotoUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_photo_uid, :string
  end
end
