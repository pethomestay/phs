class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :wants_to_be_sitter, :wants_to_be_hotel, \
                  :wants_to_be_professional_hotel, :address_1, :address_2, \
                  :address_suburb, :address_city, :address_postcode, :latitude, \
                  :longitude, :address_country, :first_name, :last_name
  has_one :hotel
  has_one :sitter
  has_many :ratings
  has_many :pets
  has_many :enquiries

  def wants_to_be_hotel?
    super || wants_to_be_professional_hotel?
  end

  geocoded_by :geocoding_address
  after_validation :geocode

  def geocoding_address
    "#{address_1}, #{address_city}, #{address_country}"
  end
end
