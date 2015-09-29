class Api::BreedsController < Api::BaseController

  # List breeds.
  # @url /breeds
  # @action GET
  def index
    @breeds = DOG_BREEDS
  end

end
