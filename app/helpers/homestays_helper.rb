module HomestaysHelper
  def my_homestay?(homestay)
    current_user && homestay == current_user.homestay
  end

  def strip_nbsp(str)
    str.gsub(/&nbsp;/i," ")
  end

  def calendar_updation_date(user)
    return "Today" if user.calendar_updated_at.blank? || user.calendar_updated_at == Date.today
    user.calendar_updated_at.strftime("%B %d, %Y")
  end

end
