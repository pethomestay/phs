class Enquiry < ActiveRecord::Base
  has_and_belongs_to_many :pets
  belongs_to              :user
  belongs_to              :provider, polymorphic: true
  attr_accessible         :pets, :user, :provider, :formatted_date, :date

  def formatted_date
    date.to_formatted_s
  end
end
