class Admin::AdminController < ApplicationController
  respond_to :html
  layout 'admin'

  before_filter :authenticate_user!
  before_filter :require_admin!

  def dashboard
    @users = User.last_five
    @homestays = Homestay.last_five
    respond_with @stats = {user_count: User.count, homestay_count: Homestay.count, pet_count: Pet.count }
  end

  protected
  def require_admin!
    render file: "#{Rails.root}/public/403", format: :html, status: 403 unless current_user.admin?
  end
end
