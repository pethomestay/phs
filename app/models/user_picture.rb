class UserPicture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true
  self.set_table_name "pictures"
  image_accessor :file
end
