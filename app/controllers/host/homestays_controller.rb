class Host::HomestaysController < Host::HostController
  skip_before_filter :require_homestay, only: [:new]

  # GET /host/homestays/new
  def new
    @homestay = current_user.build_homestay
  end

  # GET /host/homestays/edit
  def edit
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound unless @homestay
    if not @homestay.active?
      flash[:alert] = 'This listing is not active.'
    elsif @homestay.locked?
      flash[:alert] = 'This listing is locked.'
    end
  end
end
