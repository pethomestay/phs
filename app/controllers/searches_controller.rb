require './app/models/search'

class SearchesController < ApplicationController
  def create
    @search = Search.new params[:search]
    if @search.valid?
      klass = @search.provider_class
      unless @search.latitude.present? && @search.longitude.present?
        coords = Geocoder.coordinates(@search.location)
        @search.latitude = coords.first
        @search.longitude = coords.last
      end
    	@providers = klass.near([@search.latitude, @search.longitude])
      if @providers.present?
        @providers = @providers.paginate(page: params[:page], per_page: 10)
      else
        redirect_to no_results_path(location: @search.location)
      end
    else
      raise "Invalid search"
    end
  end
end
