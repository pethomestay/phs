class AdminMailer < ActionMailer::Base
  helper ApplicationHelper

  def mandrill_client
    @mandrill_client = Mandrill::API.new
  end
=begin
  def homestay_created_admin(homestay)
    @homestay = homestay
    @user = @homestay.user
    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(from: email_with_name, subject: "A Pet Homestay Host (#{@user.first_name} #{@user.last_name}) has created a new Homestay!")
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
                        :name => "first-name",
                        :content => @user.first_name
                    },
                    {
                        :name => "last-name",
                        :content => @user.last_name
                    },
                    {
                        :name => "homestay-title",
                        :content => @homestay.title
                    },
                    {
                        :name => "homestay address suburb",
                        :content => @homestay.address_suburb
                    },
                    {
                        :name => "cost-per-night",
                        :content => @homestay.cost_per_night
                    }
                ]
            }
        ]
    }
    #binding.pry
    mandrill_client.messages.send_template template_name,template_content, message
  end

  def host_rejected_paid_booking(booking)
    @booking = booking
    @user = @booking.bookee
    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(from: email_with_name, subject: "A Pet Homestay owner (#{@user.first_name} #{@user.last_name}) has declined a paid homestay booking. Booking ID: #{@booking.id}")
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: "mitul.manish@gmail.com"}],
        :subject => "hello",
        :merge_vars => [
            {
                :rcpt => "mitul.manish@gmail.com",
                :vars => [
                    {
                        :name => "email",
                        :content => @user.email
                    }
                ]
            }
        ]
    }
    #binding.pry
    mandrill_client.messages.send_template template_name,template_content, message
  end
=end
  def braintree_payment_failure_admin(booking, result)
    @booking = booking
    @user = @booking.booker
    @transaction = result
    #email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    #mail(from: email_with_name, subject: "A Guest (#{@user.first_name} #{@user.last_name}) has an issue with a BRAINTREE Payment: #{@transaction}")
    template_name = "admin_mailer_payment_failure"
    template_content = []
    message = {
        :to => [{email: @user.email}],
        :subject => "payment failure",
        :merge_vars => [
            {
                :rcpt => @user.email,
                :vars => [
                    {
                        :name => "title",
                        :content => @booking.homestay.title
                    },
                    {
                        :name => "suburb",
                        :content => @booking.homestay.address_suburb
                    },
                    {
                        :name => "url",
                        :content => homestay_url(@booking.homestay)
                    },

                    {
                        :name => "HomestayDescription",
                        :content => @booking.homestay.description
                    },
                    {
                        :name => "CostPerNight",
                        :content => @booking.homestay.cost_per_night
                    },
                    {
                        :name => "firstName",
                        :content => @user.first_name
                    },
                    {
                        :name => "lastName",
                        :content => @user.last_name
                    },
                    {
                        :name => "email",
                        :content => @user.email
                    },
                    {
                        :name => "mobile",
                        :content => @user.mobile_number
                    },
                    {
                        :name => "transaction",
                        :content => @transaction
                    }
                ]
            }
        ]
    }
    #binding.pry
    mandrill_client.messages.send_template template_name,template_content, message
  end

  def two(user)

    @user = user
    template_name = "basic"
    template_content = []
    message = {
        :to => [{email: "mitul.manish@gmail.com"}],
        :subject => "hello",
        :merge_vars => [
            {
                :rcpt => "mitul.manish@gmail.com",
                :vars => [
                    {
                        :name => "email",
                        :content => @user.last_name
                    }
                ]
            }
        ]
    }
    #binding.pry
    mandrill_client.messages.send_template template_name,template_content, message
  end

  end
