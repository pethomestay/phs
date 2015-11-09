class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  DEFAULT_RADIUS    = 20
  NUMBER_OF_RESULTS = 30
  MAXIMUM_RADIUS    = 50

  attr_accessor :provider_types, :within, :sort_by, :country
  attr_reader :location, :latitude, :longitude, :check_in_date, :check_out_date, :homestay_types,
    :pet_feeding, :pet_grooming, :pet_training, :pet_walking

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to? "#{key}="
    end
  end

  def persisted?
    false
  end

  def homestay_types=(value)
    @homestay_types = value unless value.blank?
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
    @sort_by ||= 'recommended'
  end

  def within
    @within ||= DEFAULT_RADIUS
  end

  def refined_filters
    available_filters.select { |_, value| value.present? }
  end

  def available_filters
    {
      pet_feeding: @pet_feeding,
      pet_grooming: @pet_grooming,
      pet_training: @pet_training,
      pet_walking: @pet_walking
    }
  end

  def populate_list
    perform_geocode unless @latitude.present? && @longitude.present?
    start_date = @check_in_date
    end_date   = @check_out_date
    search_dates = start_date && end_date ? (start_date..end_date).to_a : []

    # Logging code to check how long a query takes
    start_time = Time.now
    Rails.logger.debug "#{start_time}"

    results_list = []
    search_radius = 2
    # This searches for Homestays, expanding the radius of search by 5km until it reaches 30 results
    while results_list.count < NUMBER_OF_RESULTS  && search_radius <= MAXIMUM_RADIUS do
      # results_list += Homestay.available_for_enquiry(start_date, end_date).near([@latitude, @longitude], search_radius)
      homestays = Homestay.includes(:user).active.near([@latitude, @longitude], search_radius)

      # Additional filters
      if refined_filters.present?
        homestays.where(refined_filters)
      end

      if homestay_types.present?
        if homestay_types.include?('local')
          homestays = homestays.where('cost_per_night is not null')
        end
        if homestay_types.include?('remote')
          homestays = homestays.where('remote_price is not null')
        end
      end
      results_list += homestays.all
      results_list.reject! { |h| (h.unavailable_dates.collect(&:date) & (search_dates)).any? } if search_dates.any?
      search_radius += 2
    end
    search_time = Time.now
    Rails.logger.debug "Time taken for search= #{(search_time - start_time).seconds}"

    results_list = Search.algorithm(results_list.uniq) unless @sort_by == "distance"
    sort_time = Time.now
    Rails.logger.debug "Time taken for sort= #{(sort_time - search_time).seconds}"
    return results_list.uniq
  end

  # This is no longer used?
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
    Rails.logger.debug "#{start_time}"
    no_photos, results_list         = results_list.partition {|h| h.photos.empty? && h.pictures.empty? }
    Rails.logger.debug "removed no_photos #{Time.now - start_time} (#{no_photos.count}/#{results_list.count} profiles)"
    # not_responsive, results_list_2    = results_list.partition {|h| h.user.responsiveness_score.nil? || h.user.responsiveness_score < 20 }
    # puts "removed not_responsive #{Time.now - start_time}"
    has_reviews, results_list        = results_list.partition {|h| h.user.average_rating.present? && h.user.average_rating > 0 }
    Rails.logger.debug "selected for reviews #{Time.now - start_time} (#{has_reviews.count}/#{results_list.count} profiles)"
    recently_signed_up, results_list = results_list.partition {|h| h.user.created_at > Date.today - 30.days}
    Rails.logger.debug "removed old_sign_up #{Time.now - start_time} (#{recently_signed_up.count}/#{results_list.count} profiles)"
    return Search.sort_reviewed(has_reviews) + recently_signed_up.sort_by! {|h| h.user.last_sign_in_at}.reverse! + results_list.sort_by! {|h| h.user.last_sign_in_at}.reverse! + no_photos
  end

  # Sorting results with reviews first by same value, then by number of reviews

  def self.sort_reviewed(results_list)
    final_list = []
    results_list = results_list.group_by {|h| h.user.average_rating}
    results_list.keys.sort.reverse.each {|k| final_list += results_list[k].sort_by {|h| h.user.received_feedbacks.count}.reverse!}
    return final_list
  end
end
