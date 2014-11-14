class Guest::GuestController < ApplicationController
  include GuestHelper
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :set_instance_vars
  # TODO: specify the order that before_filter runs

  # GET /guest
  def index
    @conversations = Mailbox.as_guest(current_user).paginate(page: params[:page], per_page: 10)
  end
end
