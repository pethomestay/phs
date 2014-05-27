class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def update_calendar
    current_user.update_calendar
    render json: { message: "Successfully Updated" }, status: 200
  end

end
