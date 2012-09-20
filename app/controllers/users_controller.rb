class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def destroy
    current_user.update_attribute :email, "#{current_user.email}.old"
    sign_out(current_user)
  end
end
