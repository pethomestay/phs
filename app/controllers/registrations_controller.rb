class RegistrationsController < Devise::RegistrationsController
  include GuestHelper
  before_filter :authenticate_user!
  before_filter :set_instance_vars, only: [:edit]
  skip_before_filter :track_session_variables, only: [:update, :create]

  def create
    build_resource

    @rpath = after_sign_up_path_for(resource)
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_to do |format|
          format.html { redirect_to @rpath }
          format.js { render :action => :create, :layout => false }
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_to do |format|
          format.html { redirect_to @rpath }
          format.js { render :action => :create, :layout => false }
        end
      end
    else
      clean_up_passwords resource
      respond_to do |format|
        format.html { render :new }
        format.js { render :action => :create, :layout => false }
      end
    end
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def update
    @user = current_user

    successfully_updated = if @user.needs_password? && @user.valid_password?(params[:user][:current_password])
                             # Hack for update_attributes.
                             params[:user].delete("current_password")
                             params[:user].delete(:password) if params[:user][:password].empty?
                             params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].empty?
                             @user.update_attributes(params[:user])
                           else
                             # remove the virtual current_password attribute update_without_password
                             # doesn't know how to ignore it
                             params[:user].delete(:current_password)
                             @user.update_without_password(params[:user])
                             @user.homestay.update_attributes(params[:homestay])
                           end

    if successfully_updated
      set_flash_message :notice, :updated
      UserMailer.update_account(current_user).deliver
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render :edit
    end
  end

  def destroy
    current_user.update_attribute(:active, false)
    current_user.update_column(:email,"#{current_user.email}.#{Time.now.to_i}.old" )
    if current_user.homestay.present?
      current_user.homestay.update_attribute :active, false
    end
    sign_out(current_user)
    redirect_to root_path, alert: "Thanks for trying PetHomeStay."
  end

  protected
  def after_update_path_for(resource)
    guest_edit_path
  end

  def after_sign_up_path_for(resource)
    if params[:model_after_sign_up]
      session[:check_for_book_coupon] = true
    else
      session[:check_for_coupon] = true
    end
    if params[:redirect_path].present?
            (params[:model_after_sign_up] ? "#{params[:redirect_path]}##{params[:model_after_sign_up]}" : "#{params[:redirect_path]}?sign_up=true")
    else
      root_path(sign_up: true)
    end
  end
end
