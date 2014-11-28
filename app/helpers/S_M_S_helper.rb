require 'rest_client'

module SMSHelper
  SMSBROADCAST_URL = 'https://api.smsbroadcast.com.au/api-adv.php'

  def send_sms(opts)
    params = {
      username: ENV['SMSBROADCAST_USERNAME'],
      password: ENV['SMSBROADCAST_PASSWORD'],
      from: 'PetHomeStay',
      to: opts[:to],
      message: opts[:text]
    }
    RestClient.get SMSBROADCAST_URL, params: params
  end
end
