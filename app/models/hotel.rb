require './lib/provider'

class Hotel < ActiveRecord::Base
  include Provider

  attr_accessible :address_1, :address_2, :address_suburb, :address_city, :address_postcode
end
