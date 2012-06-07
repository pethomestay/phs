require './lib/provider'

class Hotel < ActiveRecord::Base
  include Provider

  attr_accessible :address_1, :address_2, :address_suburb, :address_city, \
                  :address_postcode, :address_country, :latitude, :longitude

  validates_presence_of :address_1, :address_suburb, :address_city, :address_country

  geocoded_by :geocoding_address
  after_validation :geocode, unless: Proc.new {|hotel| hotel.latitude && hotel.longitude}

  def path
    "/hotels/#{id}"
  end

  def geocoding_address
    "#{address_1}, #{address_city}, #{address_country}"
  end
end
