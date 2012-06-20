require './app/models/search'

class SearchesController < ApplicationController
  def create
    @search = Search.new params[:search]
    if @search.valid?
      providers = []
      @search.provider_classes.each do |klass|
        unless @search.latitude.present? && @search.longitude.present?
          coords = Geocoder.coordinates(@search.location)
          @search.latitude = coords.first
          @search.longitude = coords.last
        end
        within = @search.within || klass.default_within
      	provider = klass.near([@search.latitude, @search.longitude], within, order: 'distance')
        providers = providers << provider.to_a if provider.present?
      end
      if providers.present?
        providers.sort! {|a,b| a.length <=> b.length}
        longest = providers.pop
        @providers = longest.zip(*providers).flatten
        @providers.reject!(&:nil?)
        @providers = @providers.paginate(page: params[:page], per_page: 10)
      else
        redirect_to no_results_path(location: @search.location, provider_type: @search.provider_types)
      end
    else
      raise "Invalid search"
    end
  end
end
