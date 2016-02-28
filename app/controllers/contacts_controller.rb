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
        user = IntercomCreator::create_user({
          email: params[:contact][:email],
          name: params[:contact][:name]
        }) unless user.present?
        IntercomCreator::create_message({
          from: {
            type: 'user',
            email: user.email,
          },
          body: params[:contact][:message]
        })
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
      # Create user in case user does not exist in intercom
      IntercomCreator::create_user({
        email: @contact.email,
        name: @contact.name
      })
      IntercomCreator::create_note({
        email: @contact.email,
        body: "Need Homestay in #{params[:location]}"
      })
      flash[:success] = 'Success! We will keep you informed!'
    else
      flash[:error] = 'There is an error in your input. Please double check and try again.'
    end
    redirect_to :back
  end
end
