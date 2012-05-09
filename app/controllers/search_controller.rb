class SearchController < ApplicationController
  def create
  	@homestays = Homestay.all
  end
end
