class Admin::AnalyticsController < Admin::AdminController
  respond_to :html

  def index

  end

  def bookings_report
    @start_date = Date.civil(params[:start_date][:"year"].to_i,params[:start_date][:"month"].to_i,params[:start_date][:"day"].to_i)
    @end_date = Date.civil(params[:report][:"end_date(1i)"].to_i,params[:report][:"end_date(2i)"].to_i,params[:report][:"end_date(3i)"].to_i)

    respond_to do |format|
      @initial_tab_index = 5
      format.html { render :action => 'index' }

    end
  end

  def create
    @start_date = Chronic.parse(params[:start_date][:date], :endian_precedence => [:little, :median]).to_date
    @end_date = Chronic.parse(params[:end_date][:date], :endian_precedence => [:little, :median]).to_date
    @date_range = params[:date_range][:range]

    #lets get the bookings when the bookings creation date  > start_date
    #and the updated_date < end_date

    date_range_str =  "created_at >= '#{Chronic.parse(@start_date.to_s + " 00:00:00").strftime("%Y-%m-%d %H:%M:%S")}' AND updated_at <= '#{Chronic.parse(@end_date.to_s + " 23:59:59").strftime("%Y-%m-%d %H:%M:%S")}' AND "

    if @date_range == "all_data"
      date_range_str = ""
      @enquiries = Enquiry.all() #all enquires
    else
      @enquiries = Enquiry.where(date_range_str.chomp(" AND "))
    end

    @unconfirmed_enquiries  = Enquiry.where(date_range_str + "confirmed = false")
    @confirmed_enquiries  = Enquiry.where(date_range_str + "confirmed = true")
    @confirmed_bookings = Booking.where(date_range_str + "owner_accepted = true")
    @unconfirmed_bookings = Booking.where(date_range_str + "owner_accepted = false")

    @all_bookings =  @confirmed_bookings + @unconfirmed_bookings

    #lets get all the bookings relating to our enquires
    enquiry_to_booking_lengths = []

    @all_bookings.each { |booking|
      @enquiries.each { |enquiry|
        if (booking.bookee_id == enquiry.user_id and  booking.homestay_id == enquiry.homestay_id)  #we have found a booking related to the enqir
          enquiry_to_booking_lengths <<  (booking.created_at.to_date - enquiry.created_at.to_date) #Note this will give you the days
        end

      }
    }

    booking_lengths = []
    @confirmed_bookings.each {|booking |
      booking_lengths << (booking.updated_at.to_date - booking.created_at.to_date) #Note this will give you the days
    }

    sum_first_response_in_sec = []
    @enquiries.each do |enquiry|
      first_response_in_sec = first_response_in_sec_to enquiry
      sum_first_response_in_sec << first_response_in_sec if first_response_in_sec
    end
    if sum_first_response_in_sec.any?
      seconds = sum_first_response_in_sec.reduce(:+) / sum_first_response_in_sec.length unless sum_first_response_in_sec.length == 0
      hours = seconds / 3600
      seconds -= hours * 3600
      minutes = seconds / 60
      @average_first_response_time = "#{hours.round(2)} hours #{minutes.round(2)} minutes"
    else
      @average_first_response_time = 'N/A'
    end

    @average_booking_length_in_days = get_average_days(booking_lengths)
    @average_enquiry_to_booking_in_days = get_average_days(enquiry_to_booking_lengths)
    @number_of_unconfirmed_bookings =   @unconfirmed_bookings.count
    @number_of_confirmed_bookings =   @confirmed_bookings.count
    @number_of_unconfirmed_to_enquiries = @unconfirmed_enquiries.count
    @number_of_confirmed_to_enquires = @confirmed_enquiries.count
    @num_of_unresponded_enquiries = num_of_unresponded_enquiries
    @percent_of_unresponded_enquiries = (@num_of_unresponded_enquiries * 100.0 / @enquiries.count).round(2)
    @num_of_responded_enquiries = @enquiries.count - num_of_unresponded_enquiries
    @percent_of_responded_enquiries = 100 - @percent_of_unresponded_enquiries



    respond_to do |format|
      format.js

    end
  end

  def get_average_days  day_array
    @average_length_in_days = 0
    if day_array.count() >  0
      @average_length_in_days = day_array.inject{ |sum, el| sum + el }.to_f / day_array.size
    end
    return @average_length_in_days
  end

  private
  def first_response_in_sec_to enquiry
    # find first response date
    messages = Message.where(mailbox_id: enquiry.id) # fetch all messages involved in this enquiry
    return nil unless messages.length > 1 # Must have a response
    first_res_datetime = Time.now()
    # search for earliest response
    messages.each { |m| first_res_datetime = m.created_at if m.created_at < first_res_datetime and m.user_id != enquiry.user_id }
    # calculate diff
    return first_res_datetime - enquiry.created_at
  end

  def responded? enquiry
    messages = Message.where(mailbox_id: enquiry.id)
    if messages.length > 1
      true
    else
      false
    end
  end

  def num_of_unresponded_enquiries
    count = 0
    @enquiries.each do |enquiry|
      count += 1 unless responded? enquiry
    end
    count
  end
end
