class Enquiry < ActiveRecord::Base
  DURATION_OPTIONS = {
    'morning'           => "Morning",
    'afternoon'         => "Afternoon",
    'evening'           => "Evening",
    'overnight'         => "Overnight",
    '2nights'           => "2 nights",
    '3nights'           => "3 nights",
    '4nights'           => "4 nights",
    '5nights'           => "5 nights",
    '6nights'           => "6 nights",
    '7nights'           => "7 nights",
    'longerthan7nights' => "Longer"
  }

  NATURAL_DURATION = {
    'morning'           => "the morning",
    'afternoon'         => "the afternoon",
    'evening'           => "the evening",
    'overnight'         => "an overnight visit",
    '2nights'           => "2 nights",
    '3nights'           => "3 nights",
    '4nights'           => "4 nights",
    '5nights'           => "5 nights",
    '6nights'           => "6 nights",
    '7nights'           => "7 nights",
    'longerthan7nights' => "longer than 7 nights"
  }

  has_and_belongs_to_many :pets
  belongs_to              :user
  belongs_to              :homestay
  attr_accessible         :pets, :user, :homestay_id, :formatted_date, \
                          :date, :duration, :message, :responded, :accepted, \
                          :confirmed, :owner_accepted

  scope :unanswered, where(responded: false)
  scope :need_confirmation, where(responded: true, accepted: true, confirmed:false)

  scope :need_feedback, lambda { where("(date < ? AND (duration = 'morning' OR duration = 'afternoon' OR duration = 'evening' OR duration = 'overnight')) OR \
                                        (date < ? AND (duration = '2nights')) OR \
                                        (date < ? AND (duration = '3nights')) OR \
                                        (date < ? AND (duration = '4nights')) OR \
                                        (date < ? AND (duration = '5nights')) OR \
                                        (date < ? AND (duration = '6nights')) OR \
                                        (date < ? AND (duration = 'longerthan7nights'))", 2.days.ago, 3.days.ago, 4.days.ago, 5.days.ago, 6.days.ago, 7.days.ago, 8.days.ago ) }

  scope :unsent_feedback_email, where(sent_feedback_email: false)

  scope :unanswered, lambda { |user|
    if user && user.homestay
      where('(homestay_id = ? AND responded = FALSE) OR (user_id = ? AND responded = TRUE AND accepted = TRUE AND confirmed = FALSE)', user.homestay.id, user.id)
    elsif user
      where('user_id = ? AND responded = TRUE AND accepted = TRUE AND confirmed = FALSE', user.id)
    elsif user.homestay
      where('homestay_id = ? AND responded = FALSE', user.homestay.id)
    end
  }

  validates_inclusion_of :duration, :in => DURATION_OPTIONS.map(&:first)

  def formatted_date
    date.to_formatted_s
  end

  def pretty_duration
    DURATION_OPTIONS[duration] || 'Unspecified'
  end

  def natural_duration
    NATURAL_DURATION[duration] || 'unspecified'
  end
end
