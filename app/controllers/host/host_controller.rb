class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!

  # GET /host
  def index
    @host_view = true
  end
end
