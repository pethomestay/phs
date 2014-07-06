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

  def check_in_date
    params[:search][:check_in_date].present? ? params[:search][:check_in_date].to_date.strftime("%A, %d %B, %Y") : ""
  end

  def check_out_date
    params[:search][:check_out_date].present? ? params[:search][:check_out_date].to_date.strftime("%A, %d %B, %Y") : ""
  end

end
