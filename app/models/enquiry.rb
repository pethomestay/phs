class Enquiry < ActiveRecord::Base
  has_and_belongs_to_many :pets
  belongs_to              :user
  belongs_to              :homestay
  attr_accessible         :pets, :user, :homestay_id, :formatted_date, \
                          :date, :max_number_of_days

  def formatted_date
    date.to_formatted_s
  end

  def length_of_stay
    "Up to #{max_number_of_days} days"
  end
end
