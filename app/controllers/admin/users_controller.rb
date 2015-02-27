class Admin::UsersController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, (@users, @alphaParams = User.order('created_at DESC').alpha_paginate(params[:letter], js: false){|user| user.last_name}))
  end

  def show
    respond_with(:admin, @user = User.find(params[:id]))
  end

  def new
    @user = User.new
    @user.date_of_birth = Date.today
    respond_with(:admin, @user)
  end

  def edit
    respond_with(:admin, @user = User.find(params[:id]))
  end

  def create
    respond_with(:admin, @user = User.create(params[:user]))
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    respond_with(:admin, @user)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_with(:admin, @user, location: admin_users_path(letter: 'Z'))
  end

  def sign_in_as
    new_user = User.find_by_id(params[:user_id])
    if new_user
      result = sign_in(:user, new_user)
    end
    redirect_to root_path, :notice => "Signed in as #{new_user.email}"
  end
end
