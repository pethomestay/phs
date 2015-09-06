class UserMailer < ActionMailer::Base
  #layout 'mailer'
  #default from: "PetHomeStay <no-reply@pethomestay.com>"
  def mandrill_client
    @mandrill_client = Mandrill::API.new
  end
=begin
  def update_account(user)
    @user = user
    @message = 'You recently updated your account password'
    #mail(to: @user.email, subject: 'Password updated')
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "user-first-name",
                        :content =>@user.first_name
                    }

                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
  def invite_email(email, user, message = nil)
    @user = user
    @message = message
    #mail(:to => email, :subject => "Welcome to PetHomeStay")
    template_name = "user_mailer_invite_email"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "name",
                        :content => @user.first_name
                    },
                    {
                        :name => "code",
                        :content => @user.hex
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end



  def leave_feedback(to, subject, enquiry)
    @user = to
    @subject = subject
    @enquiry = enquiry
    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(to: email_with_name, subject: "#{@subject.first_name} would love some feedback!")
    template_name = "user_mailer_leave_feedback"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "subject-first-name",
                        :content => name
                    },
                    {
                        :name => "url",
                        :content => enquiry_feedback_url(@enquiry)
                    }


                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end
=begin
  def receive_message(message)
    @from = message.user
    @user = message.to_user
    @message = message
    @reservation = message.mailbox.enquiry.blank? ? message.mailbox.booking : message.mailbox.enquiry
    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    email = mail(to: email_with_name, subject: "#{@from.first_name.capitalize} has sent you a message!")
    # email.mailgun_operations = {tag: "receive_message", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "from-name",
                        :content => @from.first_name.capitalize
                    },
                    {
                        :name => "reservation-class",
                        :content => @reservation.class.to_s
                    },
                    {
                        :name => "reservation-check-in-date",
                        :content => @reservation.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "reservation-check-out-date",
                        :content => @reservation.check_out_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "message-text",
                        :content => @message.message_text
                    },
                    {
                        :name => "session-url" ,
                        :content => new_user_session_url
                    },

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
  def homestay_created(homestay)
    @homestay = homestay
    @user = @homestay.user
    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(to: email_with_name, subject: "Thank you for Applying to be a PetHomeStay Host!")
    template_name = "user_mailer_homestay_created"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
					{
                        :name => "name",
                        :content => @user.first_name
                    },
					{
                        :name => "LastName",
                        :content => @user.last_name
                    },
                    {
                        :name => "title",
                        :content => @homestay.title
                    },
                    {
                        :name => "address",
                        :content => @homestay.address_suburb
                    },
                    {
                        :name => "url",
                        :content => homestay_url(@homestay)
                    }

                ]
            }
        ]
    }
	
    mandrill_client.messages.send_template template_name,template_content, message
  end


  def homestay_approved(homestay)
    @homestay = homestay
    @user = @homestay.user
    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(to: email_with_name, subject: "Your Homestay listing has been approved!")
    template_name = "user_mailer_homestay_approved"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "cap",
                        :content => @user.first_name.capitalize
                    },
                    {
                        :name => "title",
                        :content => @homestay.title
                    },
                    {
                        :name => "address",
                        :content => @homestay.address_suburb
                    },
                     {
                        :name => "url",
                        :content => homestay_url(@homestay)
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end

=begin

  def admin_cancelled_booking(booking)
    @booking = booking
    @homestay = booking.homestay
    @user = UserDecorator.new(booking.booker)

    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(to: email_with_name, subject: "Your booking has been cancelled by the host")
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "user-first-name",
                        :content => @user.first_name.capitalize
                    },
                    {
                        :name => "booking-check-in-date",
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name =>"booking-check-in-time" ,
                        :content => @booking.check_in_time.strftime("%H:%M")
                    },
                    {
                        :name => "booking-check-out-date",
                        :content => @booking.check_out_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "booking-check-out-time",
                        :content => @booking.check_out_time.strftime("%H:%M")
                    },
                    {
                        :name => "user-last-name-cap" ,
                        :content => @user.last_name.capitalize
                    },
                    {
                        :name => "user-pet-name" ,
                        :content => @user.pet.name.capitalize
                    },
                    {
                        :name => "bookee-first-name-cap",
                        :content => @booking.bookee.first_name.capitalize
                    },
                    {
                        :name => "bookee-last-name-cap",
                        :content => @booking.bookee.last_name.capitalize
                    },
                    {
                        :name => "homestay-title" ,
                        :content => @homestay.title
                    },
                    {
                        :name => "booking-subtotal",
                        :content => @booking.subtotal
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end

  def automatically_declined(booking)
    @booking = booking
    @user = @booking.bookee
    @guest = @booking.booker
    #mail(to: @user.email, subject: "Booking automatically declined")
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "user-first-name",
                        :content => @user.first_name.capitalize.strip
                    },
                    {
                        :name => "booking-check-in-date",
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name =>"booking-check-in-time" ,
                        :content => @booking.check_in_time.strftime("%H:%M")
                    },
                    {
                        :name => "booking-check-out-date",
                        :content => @booking.check_out_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "booking-check-out-time",
                        :content => @booking.check_out_time.strftime("%H:%M")
                    },
                    {
                        :name => "guest-first-name" ,
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "guest-last-name" ,
                        :content => @guest.last_name.capitalize
                    },
                    {
                        :name => "guest-pet-name",
                        :content => @guest.pet.name.capitalize
                    },
                    {
                        :name => "booking-subtotal",
                        :content => number_to_currency(@booking.subtotal)
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end


  def guest_cancelled_booking_to_host(booking)
    @booking = booking
    @homestay = booking.homestay
    @user = UserDecorator.new(booking.bookee)
    @guest = booking.booker
    @booking_fee_refunded = booking.calculate_refund

    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(to: email_with_name, subject: "Your booking has been cancelled by the guest")
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "user-first-name",
                        :content => @user.first_name.capitalize.strip
                    },
                    {
                        :name => "booking-check-in-date",
                        :content => @booking.check_in_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "booking-check-in-time" ,
                        :content => @booking.check_in_time.strftime("%H:%M")
                    },
                    {
                        :name => "booking-check-out-date",
                        :content => @booking.check_out_date.to_formatted_s(:day_and_month)
                    },
                    {
                        :name => "booking-check-out-time",
                        :content => @booking.check_out_time.strftime("%H:%M")
                    },
                    {
                        :name => "guest-first-name" ,
                        :content => @guest.first_name.capitalize
                    },
                    {
                        :name => "guest-last-name" ,
                        :content => @guest.last_name.capitalize
                    },
                    {
                        :name => "guest-pet-name",
                        :content => @guest.pet.name.capitalize
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end

  def guest_cancelled_booking_to_guest(booking)
    @booking = booking
    @homestay = booking.homestay
    @user = booking.bookee
    @guest = booking.booker
    @days_left_until_booking_commences = booking.get_days_left
    @subtotal = booking.actual_value_figure(booking.subtotal)
    @booking_fee_refunded = booking.calculate_refund

    #email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    #mail(to: email_with_name, subject: "Your booking has been cancelled as requested")
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
                        :content => @guest.first_name.capitalize.strip
                    }

                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
end
