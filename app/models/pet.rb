class Pet < ActiveRecord::Base
  belongs_to :user
  attr_accessible :breed, :name, :type
end
