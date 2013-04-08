class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!

  def destroy
    current_user.update_attributes({active: false, email: "#{current_user.email}.#{Time.now.to_i}.old"})
    if current_user.homestay.present?
      current_user.homestay.update_attribute :active, false
    end
    sign_out(current_user)
    redirect_to root_path, alert: "Thanks for trying PetHomeStay."
  end
end
