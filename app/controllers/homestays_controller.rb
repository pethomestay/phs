class HomestaysController < ApplicationController
  require 'will_paginate/array'
  respond_to :html
  before_filter :authenticate_user!, only: [:activate, :favourite, :non_favourite]
  skip_before_filter :track_session_variables, only: [:update, :create, :availability, :show]

  layout 'new_application'

  # Performs search.
  # GET /homestays
  def index
    if search?
      session[:check_in_date]  = params[:search][:check_in_date]
      session[:check_out_date] = params[:search][:check_out_date]

      @hs = HomestaySearch.new(params[:search])
      @hs.perform_search

      @search    = @hs.search
      @homestays = @hs.results
      @homestays = @homestays.paginate(page: params[:page], per_page: 10)

      gon.push({ search: @search, homestays: @homestays })

      respond_with @homestays
    else
      redirect_to root_path
    end
  end

  def show
    @homestay = find_homestay_by_slug!
    @reviews  = @homestay.user.received_feedbacks.reviewed
    @response_rate_in_percent = @homestay.user.response_rate_in_percent
    @reusable_enquiries = current_user.enquiries.reusable if user_signed_in?
    @enquiry = build_enquiry

    if current_user.blank? && cookies[:segment_anonymous_id].nil?
      cookies.permanent[:segment_anonymous_id] = SecureRandom.hex(25)
    end

    Analytics.track(
      user_id:    current_user.try(:id) || cookies[:segment_anonymous_id],
      event:      "Viewed Product",
      properties: {
        id:       @homestay.id,
        name:     @homestay.title,
        price:    @homestay.cost_per_night,
        category: @homestay.address_city
      },
      timestamp: Time.now,
      context:   segment_io_context
    )

    gon.push fb_app_id: ENV.fetch('APP_ID', '363405197161579')

    if @homestay.inactive_listing?
      flash.now[:notice] = I18n.t('controller.homestay.show.notice.inactive')
    end
  end

  def activate
    @homestay = find_homestay_by_slug!
    @homestay.toggle!(:active)

    respond_to do |format|
      format.js
    end
  end

  def favourite
    @homestay = find_homestay_by_id
    @homestay.favourites.create!(user_id: current_user.id)

    render nothing: true
  end

  def non_favourite
    @homestay = find_homestay_by_id

    if @favourite = Favourite.where(homestay_id: @homestay.id, user_id: current_user.id).first
      @favourite.destroy
      render nothing: true
    else
      render nothing: true, status: 302
    end
  end

  private

    def build_enquiry
      Enquiry.new.tap do |e|
        if user_signed_in?
          e.user = current_user
          e.pets = current_user.pets
        end

        e.check_in_date  = Date.today
        e.check_out_date = Date.today
      end
    end

    def search?
      params[:search].present?
    end

    def find_homestay_by_slug!
      Homestay.find_by_slug!(params[:id])
    end

    def find_homestay_by_id
      Homestay.find(params[:id])
    end

    def parse_date(date)
      Time.at(date.to_i).to_date if date.present?
    end

end
