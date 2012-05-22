class HotelStepsController < ApplicationController
  before_filter :ensure_user!
  skip_before_filter :ensure_signup_completed!

  include Wicked::Wizard
  steps :basic_details, :map, :profile
  
  def show
    @hotel = get_hotel
    if step == :map
      @hotel.process_geocoding
      @map_json = @hotel.to_gmaps4rails
    end
    render_wizard
  end
  
  def update
    @hotel = get_hotel
    @hotel.update_attributes(params[:hotel])
    render_wizard @hotel
  end

  def create
    current_user.update_attributes({wants_to_be_hotel: true})
    redirect_to hotel_steps_path
  end

  def destroy
    current_user.update_attributes({wants_to_be_hotel: false})
    redirect_to root_path, alert: "Canceled desire to be a pet hotel."
  end
  
  private
  def get_hotel
    create_hotel unless current_user.hotel

    current_user.hotel
  end

  def create_hotel
    current_user.build_hotel.save
  end

  def redirect_to_finish_wizard
    redirect_to root_url
  end
end
