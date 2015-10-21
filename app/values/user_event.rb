class UserAction

  def self.value(params)
    new(params).value
  end

  def initialize(params)
    @params     = params
    @action     = @params[:action]
    @controller = @params[:controller]
  end

  def values
    # Format:
    #   "controller_name" => { "action_name" => "value" }
    #
    @values ||= {
      "pages" => {
             "home" => "Went to homepage",
          "default" => "Untracked behaviour in pages"
      },

      "homestays" => {
                  "new" => "Creating new homestay",
                 "edit" => "Changed homestay",
                "index" => "Searched for Homestay",
             "activate" => "Toggle activated for homestay",
            "favourite" => "Clicked on Favourite for Homestay",
        "non_favourite" => "Un-favourited homestay",
              "default" => "Untracked behaviour in homestays"
      },

      "registrations" => {
               "new" => "Signing up",
              "edit" => "User account edit",
            "cancel" => "Cancel Signing up",
           "destroy" => "User deleting their account",
           "default" => "Untracked behaviour in registrations"
      },

      "users/omniauth_callbacks" => {
        "default" => "Sign in/Sign up via Facebook"
      },

      "devise/confirmations" => {
        "default" => "Confirmed account"
      },

      "feedbacks" => {
        "default" => "Leaving feedback"
      },

      "users" => {
            "set_coupon" => "Applied a coupon code",
        "decline_coupon" => "Declined to use a coupon code",
                  "show" => "Looked at user: #{@params[:id]}",
                  "edit" => "Edit user details",
               "destroy" => "User deleting their account",
               "default" => "Untracked behaviour in users"
      },

      "enquiries" => {
        "default" => "New enquiry made"
      },

      "unavailable_dates" => {
         "create" => "Made date unavailable",
        "default" => "Made date available"
      },

      "guest/pets" => {
            "new" => "Creating a new pet",
           "edit" => "Editing a pet",
        "destroy" => "Deleting a pet",
         "create" => "Finished creating a new pet",
         "update" => "Finished editing pet",
          "index" => "Went to list of pets",
        "default" => "Untracked behaviour in pets screen"
      },

      "guest/messages" => {
           "create" => "Sending new message",
        "mark_read" => "Read a message",
          "default" => "Guest messages screen"
      },

      "host/host" => {
          "index" => "Host dashboard screen",
        "default" => "Untracked behaviour in host/host"
      },

      "host/homestays" => {
            "new" => "Creating a homestay",
         "create" => "Created a homestay",
           "edit" => "Editing a homestay",
         "update" => "Edited a homestay",
        "default" => "Untracked behaviour in host/homestays"
      },

      "host/bookings" => {
        "default" => "List of Host bookings page"
      },

      "unlink" => {
        "default" => "Unlinked Facebook"
      },

      "guest/accounts" => {
            "new" => "Account details screen",
           "edit" => "Account details screen",
           "show" => "Account details screen",
         "create" => "Changed bank account details",
         "update" => "Changed bank account details",
         # @FIXME
        "default" => "Untracked behaviour in host/accounts"
      },

      "host/accounts" => {
            "new" => "Account details screen",
           "edit" => "Account details screen",
           "show" => "Account details screen",
         "create" => "Changed bank account details",
         "update" => "Changed bank account details",
        "default" => "Untracked behaviour in host/accounts"
      },

      "guest/guest" => {
        "default" => "Guest dashboard screen"
      },

      "guest/favorites" => {
        "default" => "Guest favourites screen"
      },

      "bookings" => {
                "edit" => "Host or Guest reviewing enquiry",
                "show" => "Host viewing booking details",
        "host_receipt" => "Host viewing receipt for booking",
        "host_confirm" => "Host reviewing paid booking",
             "default" => "Untracked event in bookings"
      },

      "host/messages" => {
        "default" => "Host messages screen"
      },

      "default" => "Untracked behaviour"
    }
  end

  def value
    return values["default"] if values.keys.exclude? @controller
    return values[@controller]["default"] if values[@controller].keys.exclude? @action
    return values[@controller][@action] if values[@controller].keys.include? @action
  end

end
