class ContactsController < ApplicationController
  respond_to :html

  def new
    respond_with @contact = Contact.new, layout: 'new_application'
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      if user_signed_in?
        # Do nothing.
      else
        user = User.find_by_email(params[:contact][:email])
      end
      flash[:notice] = 'Your message has been sent. We usually respond within an hour or so during AEST business hours!'
      redirect_to new_contact_path
    else
      render :new, layout: 'new_application'
    end
  end

  def add_note
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      gibbon = Gibbon::API.new(ENV['MAILCHIMP_API_KEY'])
      gibbon.lists.subscribe({id: 29e7683876, email: {email: params[:contact][:email]}})
      flash[:success] = 'Success! We will keep you informed!'
    else
      flash[:error] = 'There is an error in your input. Please double check and try again.'
    end
    redirect_to :back
  end
end
