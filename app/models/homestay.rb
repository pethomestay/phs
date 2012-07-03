class Homestay < ActiveRecord::Base
  has_many :enquiries
  has_many :ratings, as: 'ratable'
  has_many :pictures, as: 'picturable'
  accepts_nested_attributes_for :pictures
  belongs_to :user

  attr_accessible :title, :description, :cost_per_night, :active, \
                  :address_1, :address_2, :address_suburb, :address_city, \
                  :address_postcode, :address_country, :latitude, :longitude
  attr_accessor :unfinished_signup

  validates_presence_of :cost_per_night
  validates_presence_of :address_1, :address_suburb, :address_city, :address_country
  validates_presence_of :title, :description, :unless => :unfinished_signup
  
  scope :active, where(active: true)

  geocoded_by :geocoding_address
  after_validation :geocode, unless: Proc.new {|hotel| hotel.latitude && hotel.longitude}

  def geocoding_address
    "#{address_1}, #{address_city}, #{address_country}"
  end

  def location
    "#{address_suburb}, #{address_city}"
  end

  def average_rating
    if ratings.present?
      ratings.inject(0) do |sum, rating|
        sum += rating.stars
      end / ratings.count
    else
      0
    end
  end
end
