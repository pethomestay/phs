class PagesController < ApplicationController
  layout 'new_application'
  before_filter :authenticate_user!, only: [:welcome]

  def home
    @check_for_coupon = params[:check_for_coupon].present? && current_user.try(:admin)
    @homepage = true
    if params[:code].present?
      cookies[:code] = params[:code]
      redirect_to root_path and return
    end
  end

  def partners
    @contact = Contact.new
  end

  def welcome; end

  def why_join_pethomestay; end

  def our_company; end

  def the_team; end

  def investors; end

  def jobs; end

  def in_the_press; end

  def charity_hosts; end
end
