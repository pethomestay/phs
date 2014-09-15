class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :host_view

  # GET /host
  def index
    @messages = true
  end

  def host_view
    @host_view = true
  end
end
