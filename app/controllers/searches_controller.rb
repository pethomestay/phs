class SearchesController < ApplicationController
  def create
    @search = Search.new params[:search]
    if @search.valid?
      klass = @search.provider_class
    	@providers = klass.near(@search.location)
      @providers = @providers.paginate(page: params[:page], per_page: 10)
    else
      raise "Invalid search"
    end
  end
end
