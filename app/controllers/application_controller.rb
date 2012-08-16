class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    if params[:redirect_path].present?
      params[:redirect_path]
    elsif resource.homestay.blank? && resource.pets.blank?
      welcome_path
    else
      my_account_path
    end
  end

  def ensure_user!
    redirect_to new_user_registration_path unless current_user
  end

  def error_404
    render 'pages/404'
  end
end
