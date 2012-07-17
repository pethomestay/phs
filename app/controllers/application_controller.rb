class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :determine_step

  def after_sign_in_path_for(resource_or_scope)
    if params[:redirect_path].present?
      params[:redirect_path]
    else
      request.env['omniauth.origin'] || root_path
    end
  end

  def ensure_user!
    redirect_to new_user_registration_path unless current_user
  end

  def error_404
    render 'pages/404'
  end

  def determine_step
    if params[:controller] == "devise/registrations"
      if params[:user]
        user = User.new(params[:user].merge({validate_first_step_only: true}))
        step = user.valid? ? 'second' : 'first'
      else
        step = 'first'
      end
      @step = ActiveSupport::StringInquirer.new(step)
    end
  end
end
