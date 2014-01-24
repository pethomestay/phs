class Admin::AdminController < ApplicationController
  respond_to :html
  layout 'admin'

  before_filter :authenticate_user!
  before_filter :require_admin!

  def dashboard
    @users = User.last_five
    @homestays = Homestay.last_five
    @enquiries = Enquiry.last_five
    respond_with @stats = {user_count: User.count, homestay_count: Homestay.count, pet_count: Pet.count, enquiries_count: Enquiry.count }
  end

end
