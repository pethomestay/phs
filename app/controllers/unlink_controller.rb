class UnlinkController < ApplicationController
  def create
    @user = User.find(params[:id])
    @user.unlink_from_facebook
    redirect_to '/users/edit', notice: "Your Facebook account has been unlinked from your profile."
  end
end