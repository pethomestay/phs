class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :ensure_signup_completed!

  def after_sign_in_path_for(resource_or_scope)
    if params[:redirect_path].present?
      params[:redirect_path]
    else
      request.env['omniauth.origin'] || root_path
    end
  end

  def ensure_signup_completed!
    return unless current_user
    if current_user.wants_to_be_hotel? && (current_user.hotel.nil? || !current_user.hotel.valid?)
      redirect_to hotel_steps_path
    elsif current_user.wants_to_be_sitter? && (current_user.sitter.nil? || !current_user.sitter.valid?)
      redirect_to sitter_steps_path
    end
  end

  def ensure_user!
    redirect_to new_user_registration_path unless current_user
  end
end
