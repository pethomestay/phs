module ShortMessagesHelper
  def send_sms(options = {})
    user = options[:to]

    default_number = '+61416168436'
    recipient_number = if Rails.env.production?
      user.mobile_number
    elsif user.email.ends_with?('@pethomestay.com')
      user.mobile_number
    else
      default_number
    end

    body = if options[:ref].blank?
      options[:text]
    else
      "#{options[:text]} [PHS:#{options[:ref]}]"
    end

    unless user.opt_out_sms
      client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
      client.account.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: recipient_number,
        body: body
      )
    end
  end

  # SMSBROADCAST_URL = 'https://api.smsbroadcast.com.au/api-adv.php'
  #
  # def send_sms(opts)
  #   default_number = '0416168436'
  #   user = opts[:to]
  #   recipient_number = if Rails.env.production?
  #     user.mobile_number
  #   elsif user.email.ends_with?('@pethomestay.com')
  #     user.mobile_number
  #   else
  #     default_number
  #   end
  #   unless user.opt_out_sms
  #     params = {
  #       username: ENV['SMSBROADCAST_USERNAME'],
  #       password: ENV['SMSBROADCAST_PASSWORD'],
  #       from: '0481070660',
  #       to: recipient_number,
  #       message: opts[:text],
  #       ref: opts[:ref]
  #     }
  #     RestClient.get SMSBROADCAST_URL, params: params
  #   end
  # end
end
