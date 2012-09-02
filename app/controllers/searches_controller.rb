require './app/models/search'
require 'will_paginate/array'

class SearchesController < ApplicationController
  def create
    if params[:search][:location].present?
      params[:search][:location] = params[:search][:location].titleize
      @search = Search.new params[:search]
      if @search.valid?
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
    unless @search.sort_by == 'average_rating'
      @homestays = Homestay.active.near([@search.latitude, @search.longitude], @search.within, order: @search.sort_by)
                           .paginate(page: params[:page], per_page: 10)
    else
      ids = Homestay.near([@search.latitude, @search.longitude], @search.within, order: 'distance').pluck(:id)
      homestays_with_feedbacks = Homestay.active.where(id: ids).includes(user: :received_feedbacks)
      @homestays = homestays_with_feedbacks.sort_by!{|h| h.average_rating}.reverse.paginate(page: params[:page], per_page: 10)
    end
  end

  def perfrom_geocode
    unless @search.latitude.present? && @search.longitude.present?
      if request.location && request.location.country != 'Reserved' && request.location.state
        coords = Geocoder.coordinates("#{@search.location}, #{request.location.state}, #{request.location.country}")
      elsif request.location && request.location.country != 'Reserved'
        coords = Geocoder.coordinates("#{@search.location}, #{request.location.country}")
      else
        coords = Geocoder.coordinates(@search.location)
      end
      @search.latitude = coords.first
      @search.longitude = coords.last
    end
  end
end
