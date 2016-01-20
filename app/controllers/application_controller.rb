class ApplicationController < ActionController::Base
  before_filter :track_session_variables
  protect_from_forgery

  def admin_login_required
    authenticate_user!
    require_admin!
  end


  def current_admin_user
    if current_user && current_user.admin?
      return current_user
    end
  end

  def require_admin!
    render file: "#{Rails.root}/public/403", format: :html, status: 403 unless current_user.admin?
  end

  def after_sign_in_path_for(resource)
    unless session[:session_id].blank?
      Analytics.alias(previous_id: session[:session_id], user_id: current_user.id)
      Analytics.identify(
        user_id: current_user.id,
        traits: {
          name: resource.name,
          email: resource.email
        }
      )
      Analytics.track(
        user_id:       current_user.id,
        event:         "Signed in",
        timestamp:     Time.now,

        context:       {
          'Google Analytics' => {
            clientId: google_analytics_client_id
            },
          'UserAgent' => request.user_agent,
          'ip' => request.ip,
        },
        integrations:  { 'Google Analytics' => false, 'KISSmetrics' => true }
      )
    end
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

  def segment_io_context
    {
      'Google Analytics' => {
        clientId: google_analytics_client_id
        },
      'UserAgent' => request.user_agent,
      'ip' => request.ip,
    }
  end

  private

  # Tags AppSignal error notifications so that they include basic user info.
  def tag_errors
    if user_signed_in?
      # Appsignal.tag_request(
      #   'User ID' => current_user.id,
      #   'User name' => "#{current_user.first_name} #{current_user.last_name}",
      #   'User email' => current_user.email
      # )
    end
  end

  # Gets
  def track_session_variables
    if current_user.present?
      Analytics.track(
        user_id:       current_user.id,
        event:         get_useable_name_of_action(params),
        properties:    params.except(:action, :controller),
        timestamp:     Time.now,
        context:       {
          'Google Analytics' => {
            clientId: google_analytics_client_id
            },
          'UserAgent' => request.user_agent,
          'ip' => request.ip,
        },
        integrations:  { 'Google Analytics' => false, 'KISSmetrics' => true }
      )

    else
      # Sets cookie if not yet set, otherwise, gets the cookie
      if cookies[:segment_anonymous_id].present?
        anonymous_id = cookies[:segment_anonymous_id]
      else
        cookies.permanent[:segment_anonymous_id] = SecureRandom.hex(25)
        anonymous_id = cookies[:segment_anonymous_id]
      end
      Analytics.track(
        user_id:          anonymous_id,
        event:            get_useable_name_of_action(params),
        properties:       params.except(:action, :controller),
        timestamp:        Time.now,
        context:       {
          'Google Analytics' => {
            clientId: google_analytics_client_id
            },
          'UserAgent' => request.user_agent,
          'ip' => request.ip,
        },
        integrations:     { 'Google Analytics' => false, 'KISSmetrics' => true }
      )
    end
  end

  def get_useable_name_of_action(action)
    case params[:controller]

    when "pages"
      case params[:action]
      when "home"
        return "Went to homepage"
      else
        return "Untracked behaviour in pages"
      end

    when "homestays"
      case params[:action]
      when "index"
        return "Searched for Homestay"
      when "favourite"
        return "Clicked on Favourite for Homestay"
      when "non_favourite"
        return "Un-favourited homestay"
      when "new"
        return "Creating new homestay"
      when "edit"
        return "Changed homestay"
      when "activate"
        return "Toggle activated for homestay"
      else
        "Untracked behaviour in homestays"
      end

    when "registrations"
      case params[:action]
      when "new"
        return "Signing up"
      when "cancel"
        return "Cancel Signing up"
      when "edit"
        return "User account edit"
      when "destroy"
        return "User deleting their account"
      else
        "Untracked behaviour in registrations"
      end

    when "users/omniauith_callbacks"
      return "Sign in/Sign up via Facebook"
    when "devise/confirmations"
      return "Confirmed account"
    when "feedbacks"
      return "Leaving feedback"

    when "users"
      case params[:action]
      when "set_coupon"
        return "Applied a coupon code"
      when "decline_coupon"
        return "Declined to use a coupon code"
      when "show"
        return "Looked at user: #{parms[:id]}"
      when "edit"
        return "Edit user details"
      when "destroy"
        return "User deleting their account"
      else
        "Untracked behaviour in users"
      end

    when "enquiries"
      return "New enquiry made"

    when "unavailable_dates"
      case params[:action]
      when "create"
        return "Made date unavailable"
      else
        return "Made date available"
      end
    when "guest/pets"
      case params[:action]
      when "new"
        return "Creating a new pet"
      when "edit"
        return "Editing a pet"
      when "destroy"
        return "Deleting a pet"
      when "create"
        return "Finished creating a new pet"
      when "update"
        return "Finished editing pet"
      when "index"
        return "Went to list of pets"
      else
        return "Untracked behaviour in pets screen"
      end

    when "guest/messages"
      case params[:action]
      when "create"
        return "Sending new message"
      when "mark_read"
        return "Read a message"
      else
        return "Guest messages screen"
      end

    when "host/host"
      case params[:action]
      when "index"
        return "Host dashboard screen"
      else
        "Untracked behaviour in host/host"
      end

    when "host/homestays"
      case params[:action]
      when "new"
        return "Creating a homestay"
      when "create"
        return "Created a homestay"
      when "edit"
        return "Editing a homestay"
      when "update"
        return "Edited a homestay"
      else
        return "Untracked behaviour in host/homestays"
      end

    when "host/bookings"
      return "List of Host bookings page"
    when "unlink"
      return "Unlinked Facebook"

    when "guest/accounts", "host/accounts"
      case params[:action]
      when "new", "edit", "show"
        return "Account details screen"
      when "create", "update"
        return "Changed bank account details"
      else
        return "Untracked behaviour in host/accounts"
      end

    when "guest/guest"
      return "Guest dashboard screen"

    when "guest/favorites"
      return "Guest favourites screen"

    when "bookings"
      case params[:action]
      when "edit"
        "Host or Guest reviewing enquiry"
      when "host_receipt"
        return "Host viewing receipt for booking"
      when "host_confirm"
        return "Host reviewing paid booking"
      when "show"
        return "Host viewing booking details"
      else
        "Untracked event in bookings"
      end

    when "host/messages"
      return "Host messages screen"

    else
      return "Untracked behaviour"
    end
  end

  def google_analytics_client_id
    google_analytics_cookie.gsub(/^GA\d\.\d\./, '')
  end

  def google_analytics_cookie
    cookies['_ga'] || ''
  end

end
