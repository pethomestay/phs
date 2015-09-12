class UserAuthenticator
  # This base authenticator contains facebook authentication at the moment
  # Extend / Subclass this class when other authentications are needed
  attr_accessor :current_user, :auth

  # Create an instance of UserAuthenticator
  #
  # @params
  #   current_user [User]
  #   auth [Hash]
  # @api public
  # @return [UserAuthenticator]
  def initialize(current_user, auth)
    @current_user = current_user
    @auth = auth
  end

  # Authenticate User
  #
  # @api public
  # @return [User]
  def authenticate
    if user.new_record? #must be a new user fill in the details
      set_user_details
      set_user_location if permissions[0]['user_location'] == 1
      set_user_age if age_info
    end

    persist_user if user.provider.nil?

    user
  end

  # Show User
  #
  # @api public
  # @return [User]
  def user
    @user ||= current_user || provider_user || email_user || new_user
  end

  private

  # Retreive graph object
  #
  # @api private
  # @return [Koala::Facebook::API]
  def graph
    @graph ||= Koala::Facebook::API.new(auth.credentials.token)
  end
  
  # Return graph object for user
  #
  # @api private
  # @return [Koala::Facebook::API]
  def me
    @me ||= graph.get_object("me")
  end

  # Return graph permissions for user
  #
  # @api private
  # @return [Koala::Facebook::API]
  def permissions
    @permissions ||= graph.get_connections('me','permissions')
  end


  # Return graph age for user
  #
  # @api private
  # @return [Koala::Facebook::API]
  def age_info
    @age_info ||= graph.get_object("me", :fields=>"age_range")
  end

  # Set user details
  #
  # @api private
  # @return [Hash]
  def set_user_details
    user.attributes = {
      email:      me["email"] ,
      password:   Devise.friendly_token[0,20],
      first_name: me["first_name"],
      last_name:  me["last_name"]
    }
  end

  # Set user location
  #
  # @api private
  # @return [Hash]
  def set_user_location
    location_info =  me["location"]
    if location_info
      user.facebook_location = location_info['name']
    end
  end

  # Set user age
  #
  # @api private
  # @return [Hash]
  def set_user_age
    user.attributes = {
      age_range_min: age_info['age_range']['min'],
      age_range_max: age_info['age_range']['max']
    }
  end

  # Persist user
  #
  # @api private
  # @return [User]
  def persist_user
    user.skip_confirmation! # don't need to confirm if this is a Facebook user
    user.update_attributes(provider: auth.provider, uid: auth.uid)
    user.save
  end

  # Find user from provider
  #
  # @api private
  # @return [User]
  def provider_user
    User.where(provider: auth.provider, uid: auth.uid).first 
  end

  # Find user from email
  #
  # @api private
  # @return [User]
  def email_user
    User.where(email: me["email"]).first 
  end

  # New user
  #
  # @api private
  # @return [User]
  def new_user
    User.new(email: me["email"], provider: auth.provider, uid: auth.uid)
  end

end
