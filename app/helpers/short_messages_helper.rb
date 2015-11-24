require 'rest_client'

module ShortMessagesHelper
  SMSBROADCAST_URL = 'https://api.smsbroadcast.com.au/api-adv.php'

  def send_sms(opts)
    default_number = '0416168436'
    user = opts[:to]
    recipient_number = if Rails.env.production?
      user.mobile_number
    elsif user.email.ends_with?('@pethomestay.com')
      user.mobile_number
    else
      default_number
    end
    unless user.opt_out_sms
      params = {
        username: ENV['SMSBROADCAST_USERNAME'],
        password: ENV['SMSBROADCAST_PASSWORD'],
        from: '0481070660',
        to: recipient_number,
        message: opts[:text],
        ref: opts[:ref]
      }
      RestClient.get SMSBROADCAST_URL, params: params
    end
  end
end
