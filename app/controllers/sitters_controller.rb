class SittersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :error_404

  def show
    @sitter = Sitter.active.find(params[:id])
    @title = @sitter.title
    @reviewed_ratings = @sitter.ratings.reviewed
    if current_user
      @my_rating = Rating.find_by_user_id_and_ratable_type_and_ratable_id(current_user.id, 'Sitter', params[:id])
    end
  end
end
