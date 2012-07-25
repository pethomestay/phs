class Enquiry < ActiveRecord::Base
  has_and_belongs_to_many :pets
  belongs_to              :user
  belongs_to              :homestay
  attr_accessible         :pets, :user, :homestay_id, :formatted_date, \
                          :date, :duration, :message, :responded, :accepted

  scope :unanswered, where(responded: false)

  def formatted_date
    date.to_formatted_s
  end
end
