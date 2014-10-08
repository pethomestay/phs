class UserPicture < ActiveRecord::Base
  extend Dragonfly::Model
  belongs_to :picturable, polymorphic: true
  self.table_name = "pictures"
  dragonfly_accessor :file, :app => :images

  validates_property :format, of: :file, in: [:jpeg, :jpg, :png, :bmp],
                     case_sensitive: false,
                     message: 'should be either .jpeg, .jpg, .png, or .bmp',
                     if: :file_changed?
end
