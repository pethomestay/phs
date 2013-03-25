class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  attr_accessor :location, :provider_types, :latitude, :longitude, :within, :sort_by, :country,
                :is_sitter, :is_homestay, :is_services

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

  def is_homestay
    @is_homestay = true if @is_homestay.nil?
    @is_homestay
  end

  def is_homestay=(val)
    @is_homestay = val == '1' ? true : false
  end

  def is_sitter
    @is_sitter = true if @is_sitter.nil?
    @is_sitter
  end

  def is_sitter=(val)
    @is_sitter = val == '1' ? true : false
  end

  def is_services
    @is_services = false if @is_services.nil?
    @is_services
  end

  def is_services=(val)
    @is_services = val == '1' ? true : false
  end

  def sitter?
    provider_types['sitter'] == '1'
  end

  def sort_by
    @sort_by ||= 'distance'
  end

  def within
    @within ||= 20
  end

  def perform
    perfrom_geocode unless @latitude.present? && @longitude.present?
    unless sort_by == 'average_rating'
      homestays = Homestay.active.near([@latitude, @longitude], within, order: sort_by)
    else
      homestays = Homestay.active.near([@latitude, @longitude], within, order: 'users.average_rating DESC').includes(:user)
    end
    homestays
  end

  def perfrom_geocode
    coords = @country && @country != 'Reserved' ? Geocoder.coordinates("#{@location}, #{@country}") :
                                                  Geocoder.coordinates(@location)
    if coords.any?
      @latitude = coords.first
      @longitude = coords.last
    end
  end
end
