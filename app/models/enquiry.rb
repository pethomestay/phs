class Enquiry < ActiveRecord::Base
  has_and_belongs_to_many :pets
  belongs_to              :user
  belongs_to              :homestay
  attr_accessible         :pets, :user, :homestay_id, :formatted_date, \
                          :date, :duration, :message, :responded, :accepted

  scope :unanswered, where(responded: false)

  validates_inclusion_of :duration, :in => %w( morning afternoon evening overnight 2days 3days 4days 5days 6days 7days longerthan7days )

  def formatted_date
    date.to_formatted_s
  end

  def pretty_duration
    case duration
      when 'morning' then 'Morning'
      when 'afternoon' then 'Afternoon'
      when 'evening' then 'Evening'
      when 'overnight' then 'Overnight'
      when '2days' then '2 days'
      when '3days' then '3 days'
      when '4days' then '4 days'
      when '5days' then '5 days'
      when '6days' then '6 days'
      when '7days' then '7 days'
      when 'longerthan7days' then 'Longer than 7 days'
    end
  end
end
