class Api::EnquiriesController < Api::BaseController
  before_filter :authenticate_user

  def create
    begin
      @enquiry = @user.enquiries.build(parsed_params)
      if @enquiry.save
        @user.save if @user.mobile_number_changed?
      else
        render_400 @enquiry.errors.full_messages
      end
    rescue ActiveRecord::RecordNotFound => e
      render_400 e.message
    end
  end

  private

  def parsed_params
    unless params[:enquiry].blank?
      enquiry_params = params[:enquiry]
      enquiry_params[:check_in_date] = enquiry_params.delete(:start_date)
      enquiry_params[:check_out_date] = enquiry_params.delete(:end_date)
      enquiry_params[:duration_id] = ReferenceData::Duration.all.last.id
    end
    enquiry_params
  end
end
