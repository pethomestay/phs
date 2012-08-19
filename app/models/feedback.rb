class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :enquiry
  attr_accessible :rating, :review

  validates_presence_of :rating
  validates_numericality_of :rating
  validates_inclusion_of :rating, :in => 1..5

  scope :reviewed, where("review != ''")
end
