require 'rest_client'

module ShortMessagesHelper
  SMSBROADCAST_URL = 'https://api.smsbroadcast.com.au/api-adv.php'

  def send_sms(opts)
    user = opts[:to]
    params = {
      username: ENV['SMSBROADCAST_USERNAME'],
      password: ENV['SMSBROADCAST_PASSWORD'],
      from: 'PetHomeStay',
      to: user.mobile_number,
      message: opts[:text]
    }
    RestClient.get SMSBROADCAST_URL, params: params
  end
end
