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
    perform_search
  end

  # Checks that the minimum required params are present.
  # Only their presence is checked - the values are not.
  # @api public
  # @raise [ArgumentError] If the params are invalid.
  # @return [Boolean] Whether the params are OK.
  def check_params
    unless (params[:latitude] && params[:longitude]) || params[:postcode]
      raise ArgumentError, 'Invalid params.'
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

  def perform_search
    @search = Search.new(params)
    @search.country = 'Australia'
    self.results = @search.populate_list
  end
end
