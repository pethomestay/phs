class Host::MessagesController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!

  def index
  end
end
