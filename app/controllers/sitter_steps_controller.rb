class SitterStepsController < ApplicationController
  before_filter :ensure_user!
  skip_before_filter :ensure_signup_completed!

  include Wicked::Wizard
  steps :basic_details, :map, :profile
  
  def show
    @sitter = get_sitter
    if step == :profile
      @picture = @sitter.pictures.build
    end
    render_wizard
  end
  
  def update
    if user_params = params[:sitter].delete(:user)
      current_user.update_attributes(user_params)
    end
    @sitter = get_sitter
    @sitter.unfinished_signup = true unless step == :profile
    @sitter.update_attributes(params[:sitter])
    if picture = params[:picture]
      @sitter.pictures.create(picture)
    end
    if @sitter.valid?
      @sitter.update_attribute(:active, true) if step == :profile
    end
    render_wizard @sitter
  end

  def create
    current_user.update_attributes({wants_to_be_sitter: true})
    redirect_to sitter_steps_path
  end

  def destroy
    current_user.update_attributes({wants_to_be_sitter: false})
    redirect_to root_path, alert: "Canceled desire to be a pet sitter."
  end
  
  private
  def get_sitter
    create_sitter unless current_user.sitter

    current_user.sitter
  end

  def create_sitter
    current_user.build_sitter
  end

  def redirect_to_finish_wizard
    redirect_to sitter_path(current_user.sitter), alert: "Your pet sitter listing has been created!"
  end
end
