
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)

    @user = UserAuthenticator.new(current_user,request.env["omniauth.auth"]).authenticate
    # The next line eliminates nil mobile numbers
    @user.update_attribute :mobile_number, 'n/a' if @user.mobile_number.blank?
    if @user.persisted?
      if current_user #we are already signed in
        redirect_to '/users/edit', notice: "Your Facebook account has been linked to your profile."
      else
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
