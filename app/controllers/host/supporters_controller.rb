class Host::SupportersController < Host::HostController
respond_to :html

  def index
    @recommendations = current_user.recommendations.order('created_at DESC').paginate(page: params[:page], per_page: 10)
  end


  def invite_emails
    @contacts = request.env['omnicontacts.contacts']
    @contacts.each do |contact|
      UserMailer.invite_email(contact[:email], current_user).deliver
    end
    redirect_to host_supporters_path, :notice => "Invitaion mail sent successfully"  
  end  
end
