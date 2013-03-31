class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, class_name: 'User'
  belongs_to :enquiry

  validates_presence_of :rating
  validates_numericality_of :rating
  validates_inclusion_of :rating, :in => 1..5

  after_save :update_user_average_rating, on: :create

  scope :reviewed, where("review != ''")

  private
  def update_user_average_rating
    user.update_average_rating
  end
end
