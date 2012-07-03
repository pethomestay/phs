require './app/models/search'

class SearchesController < ApplicationController
  def create
    if params[:search][:location].present?
      params[:search][:location] = params[:search][:location].titleize
      @search = Search.new params[:search]
      if @search.valid?
        redirect_to root_path unless @search.provider_types.present?
        @title = "Pet care for #{@search.location}"
        perform_search
      else
        raise "Invalid search"
      end
    else
      redirect_to root_path
    end
  end

  def show
    @search = Search.new({location: params[:city].capitalize})
    perform_search
    render :create if @homestays
  end

  def perform_search
    perfrom_geocode
    @homestays = Homestay.active.near([@search.latitude, @search.longitude], @search.within, order: @search.sort_by).paginate(page: params[:page], per_page: 10)
  end

  def perfrom_geocode
    unless @search.latitude.present? && @search.longitude.present?
      coords = Geocoder.coordinates(@search.location)
      @search.latitude = coords.first
      @search.longitude = coords.last
    end
  end
end
