module HomestaysHelper
  def my_homestay?(homestay)
    current_user && homestay == current_user.homestay
  end
end
