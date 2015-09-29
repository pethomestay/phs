class Host::SupportersController < Host::HostController
respond_to :html 

  # Lists out the number of recommendations/support that a user has gotten on the same page
  def index

    @recommendations = current_user.recommendations.order('created_at DESC').paginate(page: params[:page], per_page: 10)
    
    # Check Cache for user emails
    @emails = Rails.cache.fetch(current_user.hex) 
  end

  # Catch the gmail contacts data here, filter out the email addresses,
  # and add them to the cache. 
  def invite_emails
   
    @contacts ||= request.env['omnicontacts.contacts']
    @emails = @contacts.map { |contact| contact[:emails] [0][:email] if contact[:emails] } 
    
    Rails.cache.write(current_user.hex, @emails) 
   
    redirect_to host_supporters_path, :notice => "Invitaion mail sent successfully"  
  end 

  # Route for sending supporter invite emails after users have filtered through them.
  # This is an Ajax call that should return a 200 response if successful
  # or some 503 response if not successful.
  # The view is to add the logic of what to show the host and when.
  def send_invite_emails

    # get the information from JSON
    @emails = params[:emails]
    @emails.each do |address|
      UserMailer.invite_email(address, current_user).deliver
    end
    # respond to the client via json response
    msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
    render :json => msg.to_json
    
    # Remove from cache
    Rails.cache.delete(current_user.hex)
  end  
end
