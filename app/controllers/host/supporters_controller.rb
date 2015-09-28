class Host::SupportersController < Host::HostController
respond_to :html

  def index
    @recommendations = current_user.recommendations.order('created_at DESC').paginate(page: params[:page], per_page: 10)
    puts "Im being called again and again"
    @emails = Rails.cache.fetch("emails") 
  end

  def invite_emails
    @contacts ||= request.env['omnicontacts.contacts']
    @emails = @contacts.map { |contact| contact[:emails] [0][:email] if contact[:emails] } 
    puts @emails
    # listbox sect2

    Rails.cache.write("emails", @emails) 
    # @contacts.each do |contact|
      # UserMailer.invite_email(contact[:email], current_user).deliver
    # end
    redirect_to host_supporters_path, :notice => "Invitaion mail sent successfully"  
  end  



  # Route for sending supporter invite emails after users have filtered through them.
  # This is an Ajax call that should return a 200 response if successful
  # or some 503 response if not successful.
  # The view is to add the logic of what to show the host and when.
  def send_invite_emails




  end  


end
