class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, class_name: 'User'
  belongs_to :enquiry

  validates_presence_of :rating

  after_save :update_user_average_rating, on: :create

  scope :reviewed, where("review != ''")

  private
  def update_user_average_rating
    subject.update_average_rating
  end
end
