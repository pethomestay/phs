class Host::SupportersController < Host::HostController
respond_to :html

  def index
    @recommendations = current_user.recommendations.order('created_at DESC').paginate(page: params[:page], per_page: 10)
  end


  def invite_emails
    if params[:invite]
      emails = params[:invite].split(",")
      unless emails.blank?
        emails.each do |email|
          UserMailer.invite_email(email, current_user).deliver
        end
        redirect_to root_path, :notice => "Invitaion mail sent successfully"
      else
        redirect_to root_path, :notice => "Enter Valid Email address"
      end
    end  
  end  
end



