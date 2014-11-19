class ContactsController < ApplicationController
  respond_to :html

  def new
    respond_with @contact = Contact.new, layout: 'new_application'
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      @contact.send_email
      flash[:notice] = 'Your message has been sent. We usually respond within an hour or so during AEST business hours!'
      redirect_to :back
    else
      render :new, layout: 'new_application'
    end
  end
end
