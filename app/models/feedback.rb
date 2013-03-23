class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :enquiry

  validates_presence_of :rating
  validates_numericality_of :rating
  validates_inclusion_of :rating, :in => 1..5

  scope :reviewed, where("review != ''")

  def target_user
    if enquiry.user == user
      enquiry.homestay.user
    else
      enquiry.user
    end
  end
end
