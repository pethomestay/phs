class Api::HomestaysController < Api::BaseController

  def index
    @search = HomestaySearch.new(params)
    @search.perform
  end

  def show
    @homestay = Homestay.find(params[:id])
    if @homestay.blank?
      render_404 "Cannot find homestay with ID #{params[:id]}"
    end
  end

end
