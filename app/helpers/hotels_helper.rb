module HotelsHelper
  def my_hotel?(hotel)
    current_user && hotel == current_user.hotel
  end
end
