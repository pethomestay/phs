class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :wants_to_be_sitter, :wants_to_be_hotel, \
                  :wants_to_be_professional_hotel, :address_1, :address_2, \
                  :address_suburb, :address_city, :address_postcode, :latitude, \
                  :longitude
  has_one :hotel
  has_one :sitter

  def wants_to_be_hotel?
    super || wants_to_be_professional_hotel?
  end

  geocoded_by :geocoding_address
  after_validation :geocode

  def geocoding_address
    if address_1.present? && address_city.present?
      "#{address_1}, #{address_city}"
    else
      ""
    end
  end
end
