class Pet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :enquiries
  attr_accessible :breed, :name, :type
end
