class Api::HomestaysController < Api::BaseController
  def index
    @search = SearchHomestays.new(params)
    @search.perform
  end
end
