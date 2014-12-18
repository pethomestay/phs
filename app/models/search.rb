class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  DEFAULT_RADIUS    = 20
  NUMBER_OF_RESULTS = 30
  MAXIMUM_RADIUS    = 50

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

  def populate_list
    perform_geocode unless @latitude.present? && @longitude.present?
    start_date = @check_in_date
    end_date   = @check_out_date

    # Logging code to check how long a query takes
    start_time = Time.now
    puts "#{start_time}"

    results_list = []
    search_radius = 2

    # This searches for Homestays, expanding the radius of search by 5km until it reaches 30 results
    while results_list.count < NUMBER_OF_RESULTS  && search_radius <= MAXIMUM_RADIUS do
      # results_list += Homestay.available_for_enquiry(start_date, end_date).near([@latitude, @longitude], search_radius)
      results_list += Homestay.reject_unavailable_homestays(start_date, end_date).near([@latitude, @longitude], search_radius)
      search_radius += 2
    end

    search_time = Time.now
    puts "Time taken for search= #{(search_time - start_time).seconds}"
    
    # Sorting by average rating
    # results_list.uniq!.sort_by! {|h| h.user.average_rating.present? ? h.user.average_rating : 0}.reverse! if results_list.any?
    results_list = Search.algorithm(results_list)
    sort_time = Time.now
    puts "Time taken for sort= #{(sort_time - search_time).seconds}"
    return results_list.uniq
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
      homestays = homestays.available_between(check_in_date, check_out_date)
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

  # Search algorithm priority
  # Has Photos &&
  # Previous Number of Reviews
  # Last Log In Date
  # Last updated calendar
  def self.algorithm(results_list)
    return [] if results_list.empty?
    start_time = Time.now
    puts "#{start_time}"
    no_photos, results_list         = results_list.partition {|h| h.photos.empty? && h.pictures.empty? }
    puts "no_photos #{Time.now - start_time}"
    not_responsive, results_list    = results_list.partition {|h| h.user.responsiveness_score.nil? || h.user.responsiveness_score < 20 }
    puts "not_responsive #{Time.now - start_time}"
    recently_signed_up,results_list = results_list.partition {|h| h.user.created_at > Date.today - 30.days}
    puts "recent_sign_up #{Time.now - start_time}"
    no_reviews, results_list        = results_list.partition {|h| h.user.average_rating.nil? }
    puts "no_review #{Time.now - start_time}"
    results_list                    = results_list.sort_by {|h| h.user.average_rating}.reverse!
    puts "sort_by_rating #{Time.now - start_time}"
    return results_list + recently_signed_up + no_reviews + not_responsive
  end
end
