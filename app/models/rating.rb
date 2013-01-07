class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :ratable, polymorphic: true
  attr_accessible :review, :stars
  attr_accessible :review, :stars, as: :admin

  validates_presence_of :stars
  validates_numericality_of :stars

  scope :reviewed, where("review != ''")
end
