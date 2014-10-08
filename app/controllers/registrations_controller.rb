class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!
  before_filter :set_instance_vars, only: [:edit]

  def edit
    super
    if current_user.profile_photo.blank?
      resource.profile_photo = UserPicture.new
    end
  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if @user.needs_password?
                             @user.update_with_password(params[:user])
                           else
                             # remove the virtual current_password attribute update_without_password
                             # doesn't know how to ignore it
                             params[:user].delete(:current_password)
                             @user.update_without_password(params[:user])
                           end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render :edit
    end
  end

  def destroy
    current_user.update_attributes({active: false, email: "#{current_user.email}.#{Time.now.to_i}.old"})
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

  private
  # This method must be kept in sync with Guest::GuestController
  def set_instance_vars
    @unread_count = Mailbox.as_guest(current_user).where(guest_read: false).count
    @upcoming     = current_user.bookers.where('check_in_date >= ?', Date.today)
                    .order('check_in_date ASC').limit(3)
                    .select('state, check_in_date, check_out_date, bookee_id')
  end
end
