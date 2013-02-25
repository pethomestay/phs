class Admin::AdminController < ApplicationController
  respond_to :html

  def dashboard
    @users = User.last_five
    @homestays = Homestay.last_five
    respond_with @stats = {user_count: User.count, homestay_count: Homestay.count, pet_count: Pet.count }
  end
end