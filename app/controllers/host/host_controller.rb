class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :verify_homestay_existance!
  before_filter :host_view

  # GET /host
  def index
  end

  def host_view
    @host_view = true
  end

  def verify_homestay_existance!
    redirect_to new_homestay_path if current_user.homestay.blank?
  end
end
