class Admin::HomestaysController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, @homestays = Homestay.order('created_at DESC'))
  end

  def show
    respond_with(:admin, @homestay = Homestay.find_by_slug!(params[:id]))
  end

  def edit
    respond_with(:admin, @homestay = Homestay.find_by_slug!(params[:id]))
  end

  def update
    @homestay = Homestay.find_by_slug!(params[:id])
    @homestay.update_attributes(params[:homestay])
    respond_with(:admin, @homestay)
  end

  def locking
    @homestay = Homestay.find_by_slug!(params[:homestay_id])
    if @homestay.locked
      @homestay.locked = false
      @homestay.active = true
      #need to send out message to user to let them know it's approved!
      UserMailer.delay.homestay_approved(@homestay.id) #only serialize the id
    else
      @homestay.locked = true
      @homestay.active = false
    end
    @homestay.save
    respond_to do | format|
      format.js
    end
  end

  def destroy
    @homestay = Homestay.find_by_slug!(params[:id])
    @homestay.destroy

    respond_with(:admin, @homestay)
  end
end
