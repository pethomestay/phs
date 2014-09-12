class Host::RootController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!

  def index
  end
end
