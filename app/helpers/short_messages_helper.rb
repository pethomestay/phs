require 'rest_client'

module ShortMessagesHelper
  SMSBROADCAST_URL = 'https://api.smsbroadcast.com.au/api-adv.php'

  def send_sms(opts)
    user = opts[:to]
    unless user.opt_out_sms
      params = {
        username: ENV['SMSBROADCAST_USERNAME'],
        password: ENV['SMSBROADCAST_PASSWORD'],
        from: '0481070660',
        to: user.mobile_number,
        message: opts[:text],
        ref: opts[:ref]
      }
      RestClient.get SMSBROADCAST_URL, params: params
    end
  end
end
