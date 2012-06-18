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
      within = @search.within || klass.default_within
    	@providers = klass.near([@search.latitude, @search.longitude], within, order: 'distance')
      if @providers.present?
        @providers = @providers.paginate(page: params[:page], per_page: 10)
      else
        redirect_to no_results_path(location: @search.location, provider_type: @search.provider_type)
      end
    else
      raise "Invalid search"
    end
  end
end
