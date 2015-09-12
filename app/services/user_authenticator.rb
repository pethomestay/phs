class UserAuthenticator
  # This base authenticator contains facebook authentication at the moment
  # Extend / Subclass this class when other authentications are needed
  attr_accessor :current_user, :auth

  def initialize(current_user, auth)
    @current_user = current_user
    @auth = auth
  end

  def authenticate
    if user.new_record? #must be a new user fill in the details
      set_user_details
      set_user_location if permissions[0]['user_location'] == 1
      set_user_age if age_info
    end

    if user.provider.nil?
      set_provider_details
    end

    user.skip_confirmation! # don't need to confirm if this is a Facebook user
    user.save
    user
  end

  def user
    @user ||= current_user || provider_user || email_user || new_user
  end

  private

  def graph
    @graph ||= Koala::Facebook::API.new(auth.credentials.token)
  end
  
  def me
    @me ||= graph.get_object("me")
  end

  def permissions
    @permissions ||= graph.get_connections('me','permissions')
  end

  def age_info
    @age_info ||= graph.get_object("me", :fields=>"age_range")
  end

  def set_user_details
    user.attributes = {
      email:      me["email"] ,
      password:   Devise.friendly_token[0,20],
      first_name: me["first_name"],
      last_name:  me["last_name"]
    }
  end

  def set_user_location
    location_info =  me["location"]
    if location_info
      user.facebook_location = location_info['name']
    end
  end

  def set_user_age
    user.attributes = {
      age_range_min: age_info['age_range']['min'],
      age_range_max: age_info['age_range']['max']
    }
  end

  def set_provider_details
    user.provider = auth.provider
    user.uid = auth.uid
  end

  def provider_user
    User.where(provider: auth.provider, uid: auth.uid).first 
  end

  def email_user
    User.where(email: me["email"]).first 
  end

  def new_user
    User.new(email: me["email"], provider: auth.provider, uid: auth.uid)
  end

end
