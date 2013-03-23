class ContactsController < ApplicationController
  respond_to :html

  def new
    respond_with @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      @contact.send_email
      flash[:notice] = 'Your message has been sent'
      redirect_to new_contact_path
    else
      render :new
    end
  end
end
