class HomestaysController < ApplicationController
  require 'will_paginate/array'
  respond_to :html
  before_filter :authenticate_user!, except: [:show, :index, :availability]
  skip_before_filter :track_session_variables, only: [:update, :create, :availability, :show]

  SEARCH_RADIUS = 20

  #This is the action that results from a search
  def index
    redirect_to root_path and return unless params[:search]
    session[:check_in_date]  = params[:search][:check_in_date]
    session[:check_out_date] = params[:search][:check_out_date]
    @search = Search.new(params[:search])
    #We are only doing australia, not sure why we are doing the country detect
    @search.country =  'Australia' #request.location.country_code if request.location
    @homestays = @search.populate_list
    @homestays = @homestays.paginate(page: params[:page], per_page: 10)
    # @homestays = @search.perform.paginate(page: params[:page], per_page: 10)
    @title = "Pet care for #{@search.location}"
    gon.push({
      search: @search,
      homestays: @homestays,
    })
    respond_with @homestays, layout: 'new_application'
  end

  def show
    @homestay = Homestay.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @homestay
    notice = 'This listing is not active.'
    if @homestay.locked?
      notice = nil #we will change this to a message later
    end

    flash.now[:notice] = notice if notice && !@homestay.active?
    @title = @homestay.title
    @reviews = @homestay.user.received_feedbacks.reviewed
    @response_rate_in_percent = @homestay.user.response_rate_in_percent
    if current_user
      @reusable_enquiries = current_user.enquiries.where(reuse_message: true)
      @enquiry = Enquiry.new({
        user: current_user,
        pets: current_user.pets,
        check_in_date: Date.today,
        check_out_date: Date.today
      })
    elsif cookies[:segment_anonymous_id].nil?
      cookies.permanent[:segment_anonymous_id] = SecureRandom.hex(25)
      anonymous_id = cookies[:segment_anonymous_id]
    end
    unless current_user
      @enquiry = Enquiry.new({
        check_in_date: Date.today,
        check_out_date: Date.today
      })
    end
    Analytics.track(
      user_id:          current_user.try(:id) || cookies[:segment_anonymous_id],
      event:            "Viewed Product",
      properties: {
        id:       @homestay.id,
        name:     @homestay.title,
        price:    @homestay.cost_per_night,
        category: @homestay.address_city
      },
      timestamp:        Time.now,
      context:          segment_io_context,
      integrations:     { 'Google Analytics' => false, 'KISSmetrics' => true }
    )
    gon.push fb_app_id: ( ENV['APP_ID'] || '363405197161579' )
    render layout: 'new_application'
  end

  def activate
    @homestay = Homestay.find_by_slug!(params[:homestay_id])
    if @homestay.active
      @homestay.active = false
    else
      @homestay.active = true
    end
    @homestay.save
    respond_to do | format|
      format.js
    end
  end

  def favourite
    @homestay = Homestay.find params[:id]
    Favourite.create! homestay_id: @homestay.id, user_id: current_user.id
    render nothing: true
  end

  def non_favourite
    @homestay = Homestay.find params[:id]
    @fav = Favourite.where(homestay_id: @homestay.id, user_id: current_user.id).first
    if @fav
      @fav.destroy
      render nothing: true
    else
      render nothing: true, status: 302
    end
  end

  def availability
    homestay = Homestay.find(params[:id])
    start_date = Time.at(params[:start].to_i).to_date
    end_date  = Time.at(params[:end].to_i).to_date
    schedule = Scheduler.new(homestay.user, start_date: start_date, end_date: end_date)
    render json: schedule.booking_info_between.to_json, status: 200
  end
end
