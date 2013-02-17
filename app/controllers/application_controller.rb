class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    if params[:redirect_path].present?
      params[:redirect_path]
    elsif resource.homestay.blank? && resource.pets.blank?
      if params[:signup_path].present?
        welcome_path(signup_path: params[:signup_path])
      else
        welcome_path
      end
    else
      my_account_path
    end
  end
end
