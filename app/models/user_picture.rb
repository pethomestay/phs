class UserPicture
  extend Dragonfly::Model
  belongs_to :picturable, polymorphic: true
  self.table_name = "pictures"
  dragonfly_accessor :file, app: :images
end
