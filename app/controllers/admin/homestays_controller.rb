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

  def destroy
    @homestay = Homestay.find_by_slug!(params[:id])
    @homestay.destroy

    respond_with(:admin, @homestay)
  end
end
