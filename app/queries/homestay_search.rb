class HomestaySearch
  include Virtus.model

  attribute :params, Hash[Symbol => Object]
  attribute :results, Array[Homestay]

  # Setup search.
  # @api public
  # @param params [Hash]
  # @return [HomestaySearch] The query.
  def initialize(params = {})
    self.params = params
  end

  # Perform search.
  # @api public
  # @raise [ArgumentError] If the search failed.
  # @return [Fixnum] The number of results.
  def perform
    check_params
    check_location
    prepare_search
    perform_search
    augment_search
    results.size
  end

  # Checks that the minimum required params are present.
  # @api public
  # @raise [ArgumentError] If the params are invalid.
  # @return [Boolean] Whether the params are OK.
  def check_params
    unless (params[:latitude] && params[:longitude]) || params[:postcode]
      raise ArgumentError, 'Invalid params: cannot determine location.'
    end
    if params[:type].present?
      params[:type] = params[:type].downcase.split(',').collect(&:strip)
      params[:type].each do |homestay_type|
        unless ['local', 'remote'].include?(homestay_type)
          raise ArgumentError, "Invalid params: valid types are 'local' and 'remote'."
        end
      end
    end
    if params[:start].present? || params[:end].present?
      if params[:start].blank? || params[:end].blank?
        raise ArgumentError, "Invalid params: both start and end are required if one is set."
      end
      unless valid_date?(params[:start]) && valid_date?(params[:end])
        raise ArgumentError, "Invalid params: invalid date."
      end
    end
  end

  # Checks that the given location is valid.
  # Positional data is assumed to be correct. Postcodes are validated.
  # @api public
  # @raise [ArgumentError] If the postcode is invalid.
  # @return [Boolean] Whether the location is OK.
  def check_location
    if params[:latitude].blank? && params[:postcode]
      postcode = Postcode.lookup(params[:postcode])
      if postcode
        params[:latitude] = postcode.latitude
        params[:longitude] = postcode.longitude
      end
    end
  end

  # Prepares params for legacy search.
  # @api public
  # @return [Hash] The preapred params.
  def prepare_search
    if params[:type].present?
      params[:homestay_types] = if params[:type].kind_of?(Array)
        params[:type]
      else
        params[:type].downcase.split(',').collect(&:strip)
      end
    end
    if params[:start].present? && params[:end].present?
      params[:check_in_date] = params[:start]
      params[:check_out_date] = params[:end]
    end
    params
  end

  # Passes the actual searching through to legacy `Search`.
  # @note Not nice.
  # @api public
  # @return [Search] The search object.
  def perform_search
    @search = Search.new(params)
    @search.country = 'Australia'
    self.results = @search.populate_list
    @search
  end

  # Adds position and distance calculations to the seartch results.
  # @api public
  # @return [Array[Homestay]] The augmented results.
  def augment_search
    results.each_with_index do |homestay, i|
      homestay.position = i + 1
      homestay.distance = Geocoder::Calculations.distance_between(
        [params[:latitude], params[:longitude]],
        [homestay.latitude, homestay.longitude],
        units: :km
      )
    end
  end

  # Checks if the passed date is valid and in the expected format.
  # @api public
  # @param date [String] The date.
  # @return [Boolean] Whether it's valid.
  def valid_date?(date)
    if date =~ /^\d{4}-\d{2}-\d{2}$/
      begin
        Date.parse(date)
        true
      rescue ArgumentError => e
        false
      end
    else
      false
    end
  end
end
