require './lib/provider'

class Hotel < ActiveRecord::Base
  include Provider

  attr_accessible :address_1, :address_2, :address_suburb, :address_city, :address_postcode

  validates_presence_of :address_1, :address_suburb, :address_city

  acts_as_gmappable check_process: false

  def gmaps4rails_address
    "#{self.address_1}, #{self.address_city}"
  end
end
