class SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, resource)
    respond_to do |format|
      rpath = after_sign_in_path_for(resource) 
      format.html { redirect_to rpath }
      format.js { render :layout => false }
    end
  end

  def failure
    respond_to do |format|
      format.html { render :new, flash[:error] => ["Invalid Email or Password"] }
      format.js { render :action => :create, :layout => false }
    end
  end
end