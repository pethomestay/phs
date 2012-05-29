class LoginDropdownsController < ApplicationController
  def show
    html = render_to_string(partial: "layouts/navbar_login_dropdown", :layout => false)
    render json: {html: html}
  end
end
