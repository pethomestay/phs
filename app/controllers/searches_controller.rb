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
        sort_results
        @providers = @providers.paginate(page: params[:page], per_page: 10)
        @title = "Pet care for #{@search.location}"
      else
        if @search.provider_types.present?
          redirect_to no_results_path(location: @search.location, provider_type: @search.provider_types)
        else
          redirect_to root_path
        end
      end
    else
      raise "Invalid search"
    end
  end

  def sort_results
    if key = params[:search][:sort_by]
      if key != 'distance'
        @providers.sort_by! do |provider|
          provider.send(key)
        end
        @providers.reverse! if key == 'average_rating'
      end
    end
  end
end
