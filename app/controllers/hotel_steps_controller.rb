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

  def create
    current_user.wants_to_be_hotel = false
    current_user.save
    redirect_to hotel_steps_path
  end

  def destroy
    current_user.wants_to_be_hotel = false
    current_user.save
    redirect_to root_path, alert: "Canceled desire to be a pet hotel."
  end
  
  private
  def redirect_to_finish_wizard
    redirect_to root_url
  end
end
