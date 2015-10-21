class ApplicationController < ActionController::Base
  include Concerns::Analyzable

  before_filter :track_session_variables
  protect_from_forgery

  # [Ack: Not used in the code base] @deprecated
  def admin_login_required
    authenticate_user!
    require_admin!
  end

  def current_admin_user
    current_user if current_user && current_user.admin?
  end

  def require_admin!
    render file: "#{Rails.root}/public/403", format: :html, status: 403 unless current_user.admin?
  end

  def after_sign_in_path_for(resource)
    convert_visitor_to_user(session[:session_id], current_user.id)
    record_converted_visitor(current_user.id, { name: resource.name, email: resource.email })
    track(current_user.id, "Signed in")

    if params[:redirect_path].present?
      params[:redirect_path]
    elsif request.env['omniauth.origin']
      request.env['omniauth.origin']
    elsif resource.homestay.blank? && resource.pets.blank? # Newly signed up
      welcome_path
    elsif resource.homestay.present?
      host_path # Defaults to host page if homestay is present
    else
      guest_path # Default page after log in
    end
  end

  def after_sign_out_path_for(resource)
    cookies.delete :segment_anonymous_id

    root_path
  end

  private

  def track_session_variables
    if current_user.present?
      track(current_user.id, user_action, params.except(:action, :controller))
    else
      visitor = Visitor.find_or_initialize_by(cookies[:segment_anonymous_id])
      track(visitor.id, user_action, params.except(:action, :controller))
    end
  end

  def user_action
    UserAction.value(params)
  end

  def google_analytics_client_id
    google_analytics_cookie.gsub(/^GA\d\.\d\./, '')
  end

  def google_analytics_cookie
    cookies['_ga'] || ''
  end

end
