class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!

  def destroy
    current_user.update_attribute :active, false
    if current_user.homestay.present?
      current_user.homestay.update_attribute :active, false
    end
    current_user.update_attribute :email, "#{current_user.email}.#{Time.now.to_i}.old"
    sign_out(current_user)
    redirect_to root_path, alert: "Thanks for trying PetHomeStay."
  end
end
