class Guest::GuestController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!

  # GET /guest
  def index
    @messages = true
  end
end
