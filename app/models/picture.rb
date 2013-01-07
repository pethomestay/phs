class Picture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true
  image_accessor :file
  attr_accessible :file, :retained_file
  attr_accessible :file, :retained_file, as: :admin
end
