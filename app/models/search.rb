class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  DEFAULT_RADIUS = 20

  attr_accessor :location, :provider_types, :latitude, :longitude, :within, :sort_by, :country

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to? "#{key}="
    end
  end

  def persisted?
    false
  end

  def location=(value)
    @location = value.titleize
  end

  def sort_by
    @sort_by ||= 'distance'
  end

  def within
    @within ||= DEFAULT_RADIUS
  end

  def perform
    perform_geocode unless @latitude.present? && @longitude.present?
    unless sort_by == 'average_rating'
      homestays = Homestay.active.near([@latitude, @longitude], within, order: sort_by)
    else
      homestays = Homestay.active.near([@latitude, @longitude], within, order: 'users.average_rating DESC').includes(:user)
    end
    homestays
  end

  def perform_geocode
    coords = @country && @country != 'Reserved' ? Geocoder.coordinates("#{@location}, #{@country}") :
                                                  Geocoder.coordinates(@location)
    if coords && coords.any?
      @latitude = coords.first
      @longitude = coords.last
    end
  end
end
