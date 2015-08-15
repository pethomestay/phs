class SearchHomestays
  include Virtus.model

  attribute :params, Hash[Symbol => Object]

  # Setup search.
  # @api public
  # @param params [Hash]
  # @return
  def initialize(params = {})
    self.params = params
  end

  # Perform search.
  # @api public
  # @return
  def perform
  end
end
