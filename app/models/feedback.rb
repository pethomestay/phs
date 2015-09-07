class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, class_name: 'User'
  belongs_to :enquiry

  validates_presence_of :rating
  validates_numericality_of :rating
  validates_inclusion_of :rating, :in => 1..5

  after_save :update_user_average_rating, on: :create

  scope :reviewed, where("review != ''")

  # Get average rating from feedback collection
  #
  # @api public
  # @return [Integer]
  def self.average_rating
    return 0 if all.blank?

    (sum(:rating) / count.to_f).round
  end

  private

  # Update average rating of subject
  #
  # @api private
  # @return [Boolean]
  def update_user_average_rating
    subject.update_average_rating
  end
end
