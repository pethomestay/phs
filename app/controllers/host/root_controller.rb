class Host::RootController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!

  def index
    @host_view = true
  end
end
