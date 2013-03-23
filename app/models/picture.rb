class Picture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true

  image_accessor :file
end
