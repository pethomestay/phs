class PetOwnerMailer < ActionMailer::Base
  #layout 'mailer'
  #default from: "PetHomeStay <no-reply@pethomestay.com>"
  helper ApplicationHelper
  def mandrill_client
    @mandrill_client = Mandrill::API.new
  end

  def contact_details(enquiry)
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    #email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    #mail(to: email_with_name, subject: "Contact details for #{@provider.first_name}")
    template_name = "pet_owner_contact_details"
    template_content = []
    message = {
        :to => [{email: @owner.email}],
        :subject => "contact details",
        :merge_vars => [
            {
                :rcpt => @owner.email,
                :vars => [
                    {
                        :name => "ProviderFirstName",
                        :content => @provider.first_name
                    },

                    {
                        :name => "EnquiryCheckIn",
                        :content => @enquiry.check_in_date
                    },
                    {
                        :name => "OwnerPetName",
                        :content => @owner.pet_name
                    },

                    {
                        :name => "ProviderName" ,
                        :content => @provider.name
                    },
                     {
                        :name => "message" ,
                        :content => @enquiry.response_message
                    },
                    {
                        :name => "ProviderEmail" ,
                        :content => @provider.email
                    },
                    {
                        :name => "ProviderPhoneNumber" ,
                        :content => @provider.phone_number
                    },
                    {
                        :name => "MobileNumber" ,
                        :content => @provider.mobile_number
                    },
                    {
                        :name => "HomestayTitle" ,
                        :content => @homestay.title
                    },
                    {
                        :name => "url" ,
                        :content => homestay_url(@homestay)
                    },

                    {
                        :name => "HomestayAddress" ,
                        :content => @homestay.address_suburb
                    },
                    {
                        :name => "EnquiryConfirmationUrl" ,
                        :content => enquiry_confirmation_url(@enquiry)
                    }


                ]
            }
        ]
    }
	  
    mandrill_client.messages.send_template template_name,template_content, message
  end

  def booking_confirmation(booking)
    @booking = booking
    @guest = @booking.booker
    @homestay = @booking.homestay
    @host = @booking.bookee
    #email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    #email = mail(to: email_with_name, subject: "#{@host.first_name} has confirmed the booking!")
    # email.mailgun_operations = {tag: "booking_confirmation_for_guest", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "pet_owner_booking_confirmation"
    template_content = []
    message = {
        :to => [{email: @guest.email}],
        :subject => "Booking Confirmation",
        :merge_vars => [
            {
                :rcpt => @guest.email,
                :vars => [
                    {
                        :name => "HostFirstName",
                        :content => @host.first_name.capitalize
                    },
					
					{
                        :name => "HomeStayUrl",
                        :content => homestay_url(@homestay)
                    },
                    {
                        :name => "HouseRulesUrl",
                        :content => house_rules_url
                    },
                    {
                        :name => "CancellationPolicyUrl" ,
                        :content => cancellation_policy_url
                    },
                    {
                        :name => "InsurancePolicyUrl",
                        :content => insurance_policy_url
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
                        :name => "CostPerNight" ,
                        :content => @booking.actual_value_figure(:cost_per_night)
                    },
                    {
                        :name => "amount" ,
                        :content => @booking.actual_value_figure(:amount)
                    },
                    {
                        :name => "PetNames" ,
                        :content => @guest.pet_names
                    },
                    {
                        :name => "PetBreed" ,
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "HomeStayTitle" ,
                        :content => @homestay.title
                    },
                    {
                        :name => "HomeStayAddress" ,
                        :content => @homestay.address_suburb
                    },
                    {
                        :name => "HostName" ,
                        :content => @host.name
                    },
                    {
                        :name => "HostEmail" ,
                        :content => @host.email
                    },
                    {
                        :name => "HostPhoneNumber" ,
                        :content => @host.phone_number
                    },
                    {
                        :name => "HostMobileNumber" ,
                        :content => @host.mobile_number
                    },
                    {
                        :name => "HomeStayAddress1" ,
                        :content => @homestay.address_1
                    },
                    {

                        :name => "HomeStaySuburb" ,
                        :content => @homestay.address_suburb
                    },

                    {
                        :name => "HomeStayCity" ,
                        :content => @homestay.address_city
                    },
                    {
                        :name => "HomeStayAddress2" ,
                        :content => @homestay.address_2
                    }

                ]
            }
        ]
    }
	
    mandrill_client.messages.send_template template_name,template_content, message
  end
=begin
  def provider_unavailable(enquiry)
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    #email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    #email = mail(to: email_with_name, subject: "#{@provider.first_name} is unavailable")
    # email.mailgun_operations = {tag: "provider_unavailable", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @owner.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @owner.email,
                :vars => [
                    {
                        :name => "owner-first-name",
                        :content => @owner.first_name
                    },
                    {
                        :name => "provider-first-name",
                        :content => @provider.first_name
                    },
                    {
                        :name => "response-message",
                        :content => @enquiry.response_message
                    },
                    {
                        :name => "homestay-title",
                        :content => @homestay.title
                    },
                    {
                        :name => "enquiry-check-in-date",
                        :content => date_day_monthname(@enquiry.check_in_date)
                    },


                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
  def host_enquiry_response(enquiry)
	  
    @enquiry = enquiry
    @guest = @enquiry.user
    @homestay = @enquiry.homestay
    @host = @homestay.user
    #email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    #email = mail(to: email_with_name, subject: "#{@host.first_name.capitalize} has sent you a message!")
    # email.mailgun_operations = {tag: "host_enquiry_response", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "pet_owner_host_enquiry_response"
    template_content = []
    message = {
        :to => [{email: @guest.email}],
        :subject => "Enquiry response",
        :merge_vars => [
            {
                :rcpt => @guest.email,
                :vars => [
                    {
                        :name => "GuestFirstNameCap",
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "HostFirstNameCap",
                        :content => @host.first_name.capitalize
                    },
                    {
                        :name => "HomestayTitle",
                        :content => @homestay.title.capitalize
                    },
                    {
                        :name => "GuestPetNames",
                        :content =>@guest.pet_names
                    },
                    {
                        :name => "GuestPetBreed",
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "GuestPetAge" ,
                        :content => @guest.pets.map(&:age).to_sentence
                    },
                    {
                        :name => "EnquiryCheckInDate" ,
                        :content => @enquiry.check_in_date
                    },
                    {
                        :name => "EnquiryCheckOutDate" ,
                        :content => @enquiry.check_out_date
                    },
                    {
                        :name => "MessageResponse" ,
                        :content => @enquiry.response_message
                    },

                    {
                        :name => "GuestMessageUrl" ,
                        :content => guest_messages_url
                    },
                    {
                        :name => "NewBookingUrl" ,
                        :content => new_booking_url(enquiry_id: @enquiry.id)
                    }
                ]
            }
        ]
    }
	  
    mandrill_client.messages.send_template template_name,template_content, message
  end
=begin
  def provider_not_available(booking)
    @booking = booking
    @guest = booking.booker
    @homestay = booking.homestay
    @host = booking.bookee
    #email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    #subject = "#{@guest.first_name.capitalize} - You have a new PetHomeStay Message!"
    #email = mail(to: email_with_name, subject: subject)
    # email.mailgun_operations = {tag: "provider_not_available", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @guest.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @guest.email,
                :vars => [
                    {
                        :name => "guest-first-name-cap",
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "host-first-name-cap",
                        :content => @host.first_name.capitalize
                    },
                    {
                        :name => "host-name-cap",
                        :content => @host.name.capitalize
                    },
                    {
                        :name => "homestay.title",
                        :content => @homestay.title.capitalize
                    },

                    {
                        :name => "response-message",
                        :content => @booking.response_message
                    },
                    {
                        :name => "guest-message-url",
                        :content => guest_messages_url
                    },
                    {
                        :name => "host-name-cap" ,
                        :content => @host.name.capitalize
                    },
                    {
                        :name => "" ,
                        :content => @homestay.title.capitalize
                    },
                    {
                        :name => "guest-pet-names" ,
                        :content => @guest.pet_names
                    },
                    {
                        :name => "guest-pet-breed" ,
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "booking-check-in-date" ,
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "booking-check-out-date" ,
                        :content => @booking.check_out_date.to_formatted_s(:day_and_month)

                    },
                    {
                        :name => "root-url" ,
                        :content => root_url
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
  def provider_has_question(booking, message)
    @booking = booking
    @guest = booking.booker
    @homestay = booking.homestay
    @host = booking.bookee
    @message = message
    #email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    #subject = "#{@guest.first_name.capitalize} - You have a new PetHomeStay Message!"
    #email = mail(to: email_with_name, subject: subject)
    # email.mailgun_operations = {tag: "provider_has_question", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "pet_owner_provider_has_question"
    template_content = []
    message = {
        :to => [{email: @guest.email}],
        :subject => "Host message",
        :merge_vars => [
            {
                :rcpt => @guest.email,
                :vars => [
                    {
                        :name => "GuestFirstNameCapital",
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "HostFirstName",
                        :content => @host.first_name
                    },
                    {
                        :name => "HomestayTitle",
                        :content => @homestay.title
                    },
                    {
                        :name => "BookingCheckInDate",
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "GuestMessageUrl",
                        :content => guest_messages_url
                    },
                    {
                        :name => "message",
                        :content => @message
                    },

                    {
                        :name => "GuestPetNames" ,
                        :content => @guest.pet_names
                    },
                    {
                        :name => "GuestPetBreed" ,
                        :content => @guest.pet_breed
                    }

                ]
            }
        ]
    }
	  
    mandrill_client.messages.send_template template_name,template_content, message
  end
=begin
  def booking_receipt(booking)
    @booking = booking
    @guest = @booking.booker
    @homestay = @booking.homestay
    @host = @homestay.user
    #email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    #email = mail(to: email_with_name, subject: "Booking has been made and a response is pending")
    # email.mailgun_operations = {tag: "booking_receipt", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @guest.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @guest.email,
                :vars => [
                    {
                        :name => "host-first-name",
                        :content => @host.first_name.capitalize
                    },
                    {
                        :name => "hosr-email",
                        :content => @host.email
                    },
                    {
                        :name => "host-phone-number",
                        :content => @host.phone_number
                    },
                    {
                        :name => "",
                        :content => @host.mobile_number
                    },
                    {
                        :name => "homestay-title",
                        :content => @homestay.title
                    },
                    {
                        :name => "homestay-address" ,
                        :content => @homestay.address_suburb
                    },
                    {
                        :name => "booking-check-in-date" ,
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                    :name => "bookking-check-out-date",
                    :content => @booking.check_out_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "booking-number-of-nights",
                        :content => @booking.number_of_nights
                    },
                    {
                        :name => "cost-per-night",
                        :content => @booking.actual_value_figure(:cost_per_night)
                    },
                    {
                        :name => "",
                        :content => @booking.actual_value_figure(:subtotal)
                    },
                    {
                        :name => "transaction-fee",
                        :content => @booking.transaction_fee
                    },
                    {
                        :name => "amount" ,
                        :content => @booking.actual_value_figure(:amount)
                    },
                    {
                        :name => "pet-names" ,
                        :content => @guest.pet_names
                    },
                    {
                        :name => "pet-breed" ,
                        :content => @guest.pet_breed
                    },
                    {
                        :name => "booking-message" ,
                        :content => @booking.message
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
end
