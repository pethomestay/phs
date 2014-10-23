class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  DEFAULT_RADIUS = 20

  attr_accessor :provider_types, :within, :sort_by, :country
  attr_reader :location, :latitude, :longitude, :check_in_date, :check_out_date

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to? "#{key}="
    end
  end

  def persisted?
    false
  end

  def check_in_date=(value)
    @check_in_date = value.to_date if value.respond_to?(:to_date)
  end

  def check_out_date=(value)
    @check_out_date = value.to_date if value.respond_to?(:to_date)
  end

  def location=(value)
    @location = value.titleize
  end

  def latitude=(value)
    @latitude = value unless value.blank?
  end

  def longitude=(value)
    @longitude = value unless value.blank?
  end

  def sort_by
    @sort_by ||= 'distance'
  end

  def within
    @within ||= DEFAULT_RADIUS
  end

  def perform
    perform_geocode unless @latitude.present? && @longitude.present?
    if sort_by != 'average_rating'
      homestays = Homestay.active.near([@latitude, @longitude], within, order: sort_by)
    else
      homestays = Homestay.active.near([@latitude, @longitude], within, order: 'users.average_rating DESC')
    end
    if self.check_in_date.present?
      check_out_date = self.check_out_date || self.check_in_date + 1.day
      homestays = homestays.available_between(check_in_date, check_out_date).not_booked_between(check_in_date, check_out_date)
    end
    homestays.includes(:user)
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
