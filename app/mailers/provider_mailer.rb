class ProviderMailer < ActionMailer::Base
  helper ApplicationHelper

  def mandrill_client
    @mandrill_client = Mandrill::API.new
  end


  def enquiry(enquiry)
    @enquiry = enquiry
    @guest = @enquiry.user
    @pets = @guest.pets
    @host = enquiry.homestay.user
    #email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
    #email = mail(to: email_with_name, subject: "#{@host.first_name.capitalize} - You have a new PetHomeStay Message!")
    # email.mailgun_operations = {tag: "enquiry", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "provider_mailer_enquiry"
    template_content = []
    message = {
        :to => [{email: @host.email}],
        :subject => "Enquiry",
        :merge_vars => [
            {
                :rcpt => @host.email,
                :vars => [
                    {
                        :name => "GuestFirstName",
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "EnquiryMessage",
                        :content => @enquiry.message
                    },
                    {
                        :name => "HostMessageUrl",
                        :content => host_messages_url
                    },

                    {
                        :name => "CheckInDate",
                        :content => @enquiry.check_in_date
                    },
                    {
                        :name => "CheckOutDate",
                        :content => @enquiry.check_out_date
                    },
                    {
                        :name => "PetName",
                        :content => @guest.pet_names
                    },
                    {
                        :name => "PetBreed" ,
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "PetAge" ,
                        :content => @guest.pets.map(&:age).to_sentence
                    }
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end

  def owner_confirmed(booking)
    @booking = booking
    @enquiry = @booking.enquiry
    @guest = @booking.booker
    @pets = @guest.pets
    @host = @booking.bookee
    template_name = "provider_mailer_owner_confirmed"
    template_content = []
    message = {
        :to => [{email: @host.email}],
        :subject => "pet owner confirmation",
        :merge_vars => [
            {
                :rcpt => @host.email,
                :vars => [
                    {
                        :name => "GuestFirstName",
                        :content => @guest.first_name.capitalize
                    },

                    {
                        :name => "GuestMobile",
                        :content => @guest.mobile_number
                    },

                    {
                        :name => "PetName",
                        :content => @guest.pet_names
                    },
                    {
                        :name => "PetBreed",
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "PetAge",
                        :content => @guest.pets.map(&:age).to_sentence
                    },
                    {
                        :name => "CheckInDate",
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "CheckOutDate" ,
                        :content => @booking.check_out_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "NumberOfNights" ,
                        :content => @booking.number_of_nights
                    },
                    {
                        :name => "CostPerNight",
                        :content => @booking.actual_value_figure(:cost_per_night)
                    },
                    
                    {
                        :name => "PhsServiceCharge",
                        :content => @booking.phs_service_charge
                    },
                    {
                        :name => "BookingHostPayout",
                        :content => @booking.host_payout
                    },
                    {
                        :name => "BookingMessage",
                        :content => @booking.message
                    },
                    {
                        :name => "HostMessageUrl",
                        :content => host_messages_url
                    }

                ]
            }
        ]
    }
    #email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
    #subject =  "#{@host.first_name.capitalize} - You have a new PetHomeStay Booking!"
    #email = mail(to: email_with_name, subject: subject)
    # email.mailgun_operations = {tag: "owner_confirmed", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    mandrill_client.messages.send_template template_name,template_content, message
  end

  def owner_cancelled(enquiry)
    @enquiry = enquiry
    @user = @enquiry.user
    @pets = @user.pets
    @provider = enquiry.homestay.user
    template_name = "provider_mailer_owner_cancelled"
    template_content = []
    message = {
        :to => [{email: @provider.email}],
        :subject => "Updated pethomestay booking",
        :merge_vars => [
            {
                :rcpt => @provider.email,
                :vars => [
                    {
                        :name => "ProviderFirstName",
                        :content => @provider.first_name
                    },
                    {
                        :name => "UserFirstName",
                        :content => @user.first_name
                    },
                    {
                        :name => "PetLength",
                        :content => 'pet'.pluralize(@user.pets.length)
                    },
                    {
                        :name => "PetNames",
                        :content => @user.pet_names
                    },
                    {
                        :name => "CheckInDate",
                        :content => @enquiry.check_in_date
                    }

                ]
            }
        ]
    }
    #email_with_name = "#{@provider.first_name} #{@provider.last_name} <#{@provider.email}>"
    #mail(to: email_with_name, subject: "#{@user.first_name.capitalize} isn't going ahead with their booking!")
    mandrill_client.messages.send_template template_name,template_content, message
  end
=begin
  def booking_confirmation(booking)
    @booking = booking
    @guest = @booking.booker
    @homestay = @booking.homestay
    @host = @homestay.user
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @host.email}],
        :subject => "Booking Confirmed",
        :merge_vars => [
            {
                :rcpt => @host.email,
                :vars => [
                    {
                        :name => "GuestFirstName",
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "PetName",
                        :content => @guest.pet_names
                    },
                    {
                        :name => "PetBreed",
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "PetAge",
                        :content => @guest.pets.map(&:age).to_sentence
                    },
                    {
                        :name => "CheckInDate",
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "CheckOutDate",
                        :content => @booking.check_out_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "NumberOfNights",
                        :content => @booking.number_of_nights
                    },
                    {
                        :name => "CostPerNight",
                        :content => @booking.actual_value_figure(:cost_per_night)
                    },
                    {
                        :name => "SubTotal" ,
                        :content => @booking.actual_value_figure(:subtotal)
                    },
                    {
                        :name => "PhsServiceCharge" ,
                        :content => @booking.phs_service_charge
                    },
                    {
                        :name => "Insurance",
                        :content => @booking.public_liability_insurance
                    },
                    {
                        :name => "BookingHostPayout",
                        :content => @booking.host_payout
                    }
                ]
            }
        ]
    }
    #email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
    #email = mail(to: email_with_name, subject: "You have confirmed the booking with #{@guest.first_name.capitalize}!")
    # email.mailgun_operations = {tag: "booking_confirmation_for_host", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
  def booking_made(booking)
    @booking = booking
    @guest = @booking.booker
    @homestay = @booking.homestay
    @host = @homestay.user
    template_name = "provider_mailer_booking_made"
    template_content = []
    message = {
        :to => [{email: @host.email}],
        :subject => "PetHomeStay Booking Receipt",
        :merge_vars => [
            {
                :rcpt => @host.email,
                :vars => [
                    {
                        :name => "GuestFirstName",
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "GuestEmail",
                        :content => @guest.email
                    },
                    {
                        :name => "GuestMobile",
                        :content => @guest.mobile_number
                    },
                    {
                        :name => "GuestPhone",
                        :content => @guest.phone_number
                    },
                    {
                        :name => "BookingStartTime",
                        :content => @booking.check_in_date.strftime("%A, %d/%m/%Y")
                    },

                    {
                        :name => "PetName",
                        :content => @guest.pet_names
                    },
                    {
                        :name => "PetBreed",
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "PetAge",
                        :content => @guest.pets.map(&:age).to_sentence
                    },

                    {
                        :name => "CheckInDate",
                        :content => @booking.check_in_date.strftime("%A, %d/%m/%Y")
                    },
                    {
                        :name => "CheckOutDate",
                        :content => @booking.check_out_date.strftime("%A, %d/%m/%Y")
                    },
                    {
                        :name => "NumberOfNights" ,
                        :content => @booking.number_of_nights
                    },
                    {
                        :name => "CostPerNight" ,
                        :content => @booking.cost_per_night
                    },
                    {
                        :name => "insurance",
                        :content => @booking.public_liability_insurance
                    },
                    {
                        :name => "subtotal",
                        :content => @booking.actual_value_figure(:subtotal)
                    },
                    {
                        :name => "ServiceCharge",
                        :content => @booking.phs_service_charge
                    },

                    {
                        :name => "BookingHostPayout",
                        :content => @booking.host_payout
                    }
                ]
            }
        ]
    }

    #email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
    #email = mail(to: email_with_name, subject: "Booking for #{@guest.first_name.capitalize} completed!")
    # email.mailgun_operations = {tag: "booking_made_for_host", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    mandrill_client.messages.send_template template_name,template_content, message
  end

  private
  def trim(mobile)
    mobile.gsub(/[^0-9]/, "")
    case mobile.length
      when 10 # 0416 123 456
        return '61' + mobile[1..-1]
      when 11 # 61 416 291 496
        return mobile
      when 13 # 0061 416 123 456
        return mobile[2..-1]
      else
        return nil
    end
  end
end
