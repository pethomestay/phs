class SearchesController < ApplicationController
  def create
    @search = Search.new params[:search]
    if @search.valid?
    	@providers = @search.provider_class.all
      @providers = @providers.paginate(page: params[:page], per_page: 10)
    else
      raise "Invalid search"
    end
  end
end
