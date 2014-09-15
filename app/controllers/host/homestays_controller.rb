class Host::HomestaysController < Host::HostController
  # GET /host/homestays/edit
  def edit
    @my_homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound unless @my_homestay
    if not @my_homestay.active?
      notice = 'This listing is not active.'
    elsif @my_homestay.locked?
      notice = 'This listing is locked.'
    end
    flash.now[:notice] = notice if notice
  end
end
