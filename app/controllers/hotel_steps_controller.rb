class HotelStepsController < ApplicationController
  before_filter :ensure_user!
  skip_before_filter :ensure_signup_completed!

  include Wicked::Wizard
  steps :basic_details, :map, :profile
  
  def show
    @hotel = current_user.build_hotel
    render_wizard
  end
  
  def update
    @hotel = current_user.build_hotel(params[:hotel])
    render_wizard @hotel
  end
  
  private
  def redirect_to_finish_wizard
    redirect_to root_url
  end
end
