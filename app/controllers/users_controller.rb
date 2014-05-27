class UsersController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def show
    respond_with @user = current_user
  end

  def update_calendar
    current_user.update_calendar
    render json: { message: "Successfully Updated" }.to_json, status: 200
  end

end
