class UserPicture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true
  self.table_name = "pictures"
  image_accessor :file
end
