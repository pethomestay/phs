class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    if resource.class == AdminUser
      admin_dashboard_path
    else
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

  def ensure_user!
    redirect_to new_user_registration_path unless current_user
  end

  def error_404
    render 'pages/404'
  end
end
