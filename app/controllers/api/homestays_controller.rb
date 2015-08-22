class Api::HomestaysController < Api::BaseController

  #
  def index
    @search = HomestaySearch.new(params)
    begin
      @search.perform
    rescue ArgumentError => e
      render_400 e.message
    end
  end

  #
  def show
    @homestay = Homestay.where(id: params[:id]).first
    if @homestay.blank?
      render_404 "Cannot find Homestay with ID: #{params[:id]}."
    end
  end

end
