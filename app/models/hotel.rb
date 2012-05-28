require './lib/provider'

class Hotel < ActiveRecord::Base
  include Provider

  attr_accessible :address_1, :address_2, :address_suburb, :address_city, :address_postcode

  validates_presence_of :address_1, :address_suburb, :address_city

  geocoded_by :geocoding_address
  after_validation :geocode

  def path
    "/hotels/#{id}"
  end

  def geocoding_address
    if address_1.present? && address_city.present?
      "#{address_1}, #{address_city}"
    else
      ""
    end
  end
end
