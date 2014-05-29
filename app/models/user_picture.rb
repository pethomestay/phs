class UserPicture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true
  self.table_name = "pictures"
  dragonfly_accessor :file, app: :images
end
