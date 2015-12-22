class HomestaysController < ApplicationController
  require 'will_paginate/array'
  respond_to :html
  before_filter :authenticate_user!, except: [:show, :index, :availability]
  skip_before_filter :track_session_variables, only: [:update, :create, :availability, :show]

  SEARCH_RADIUS = 20

  def index
    if params[:referer]
      @referer = params[:referer].to_sym
      params[:search] ||= {}
      params[:search][:location] ||= (params[:postcode] || '2000')
    end
    redirect_to root_path and return unless params[:search]
    session[:check_in_date]  = params[:search][:check_in_date]
    session[:check_out_date] = params[:search][:check_out_date]
    @search = Search.new(params[:search])
    @homestays = @search.populate_list
    @homestays = @homestays.paginate(page: params[:page], per_page: 10)
    @title = "Pet care for #{@search.location}"
    gon.push({
      search: @search,
      homestays: @homestays,
    })
    respond_with @homestays, layout: 'new_application'
  end

  def show
    @renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    @homestay = Homestay.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @homestay
    @title = @homestay.title
    @reviews = @homestay.user.received_feedbacks.reviewed.order('created_at desc')
    @accepted_pet_sizes = @homestay.pet_sizes.collect{|size| size.sub(/(\w+).*/, '\1').downcase}
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
    info = homestay.user.booking_info_between(start_date, end_date)
    render json: info.to_json, status: 200
  end
end
