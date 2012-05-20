class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :ensure_signup_completed!

  def ensure_signup_completed!
    return unless current_user
    if current_user.wants_to_be_hotel? && current_user.hotel.nil?
      redirect_to hotel_steps_path
    end
  end

  def ensure_user!
    redirect_to new_user_registration_path unless current_user
  end
end
