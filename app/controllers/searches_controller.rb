class SearchesController < ApplicationController
  def create
    @search = Search.new params[:search]
    if @search.valid?
    	@providers = @search.provider_class.all
    else
      raise "Invalid search"
    end
  end
end
