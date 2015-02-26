class RecommendationsController < ApplicationController
  skip_before_filter :track_session_variables
  before_filter :authenticate_user!, :only => [:index]
  before_filter :set_user_params, :only => [:create]
  layout "new_application"

  def index
    @recommendations = current_user.recommendations
  end

  def show
    @recommendation = Recommendation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recommendation }
    end
  end

  def new
    @user = User.find_by_hex(params[:hex])
    @recommendation = Recommendation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recommendation }
    end
  end

  # def edit
  #   @recommendation = Recommendation.find(params[:id])
  # end

  def create
    @recommendation = Recommendation.new(params[:recommendation])

    # User creation
    if User.find_by_email(params[:recommendation][:email]).nil?
      temp_pw = SecureRandom.hex(10)
      User.new({:email => params[:recommendation][:email], :password => temp_pw, :password_confirmation => temp_pw, :first_name => params[:name].split(" ").first, :last_name => params[:name].split(" ").last}).save(:validate => false)
    end

    respond_to do |format|
      if @recommendation.save
        format.html { redirect_to root_path, notice: 'Recommendation was successfully created.' }
        format.json { render json: @recommendation, status: :created, location: @recommendation }
      else
        format.html { render action: "new" }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # def update
  #   @recommendation = Recommendation.find(params[:id])

  #   respond_to do |format|
  #     if @recommendation.update_attributes(recommendation_params)
  #       format.html { redirect_to @recommendation, notice: 'Recommendation was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @recommendation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_to recommendations_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def set_user_params
      hex = params[:recommendation][:user_id]
      params[:recommendation][:user_id] = User.find_by_hex(hex).id
      redirect_to root_path, :notice => "You can't recommend yourself" and return if current_user && params[:recommendation][:user_id] == current_user.id
    end


end
