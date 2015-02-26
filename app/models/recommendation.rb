class Recommendation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :review, :user_id, :email

  # Email is of the person who is leaving the recommendation
  # User is the person being recommended (i.e. subject)

  # Need to create validation for email to user

end
