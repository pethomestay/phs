class UsersController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def show
    respond_with @user = current_user
  end
end
