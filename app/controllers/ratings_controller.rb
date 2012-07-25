class RatingsController < ApplicationController
  def update
    if current_user
      klass = env['PATH_INFO'].split('/').second.singularize.capitalize
      @rating = Rating.find_or_create_by_user_id_and_ratable_type_and_ratable_id(current_user.id, klass, params[:homestay_id])
      @rating.update_attributes(params[:rating])
      render json: @rating.to_json
    else
      render nothing: true, status: 401
    end
  end
end
