class SittersController < ApplicationController
  def show
    @sitter = Sitter.find(params[:id])
    @title = @sitter.title
  end
end
