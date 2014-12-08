class ContactsController < ApplicationController
  respond_to :html

  def new
    respond_with @contact = Contact.new, layout: 'new_application'
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      if user_signed_in?
        Intercom::Message.create({
          from: {
            type: 'user',
            user_id: current_user.id,
          },
          body: params[:contact][:message]
        })
      else
        user = User.find_by_email(params[:contact][:email])
        user = Intercom::User.create(email: params[:contact][:email], name: params[:contact][:name]) unless user.present?
        Intercom::Message.create({
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
      Intercom::User.create email: @contact.email, name: @contact.name
      Intercom::Note.create email: @contact.email,
                            body: "Need Homestay in #{params[:location]}"
      flash[:success] = 'Success! We will keep you informed!'
    else
      flash[:error] = 'There is an error in your input. Please double check and try again.'
    end
    redirect_to :back
  end
end
