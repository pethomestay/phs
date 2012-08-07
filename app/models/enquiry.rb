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

  has_and_belongs_to_many :pets
  belongs_to              :user
  belongs_to              :homestay
  attr_accessible         :pets, :user, :homestay_id, :formatted_date, \
                          :date, :duration, :message, :responded, :accepted

  scope :unanswered, where(responded: false)

  validates_inclusion_of :duration, :in => DURATION_OPTIONS.map(&:first)

  def formatted_date
    date.to_formatted_s
  end

  def pretty_duration
    DURATION_OPTIONS[duration] || 'Unspecified'
  end
end
