class RemoveProfilePhotoUidFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :profile_photo_uid
  end

  def down
    add_column :users, :profile_photo_uid, :string
  end
end
