require 'rest_client'

module SMS
  SMSGLOBAL_URL = 'http://www.smsglobal.com/http-api.php'

  def send_sms(opts)
    params = {
      action: 'sendsms',
      user: ENV['SMSGLOBAL_USERNAME'],
      password: ENV['SMSGLOBAL_PASSWORD'],
      from: 'PetHomeStay',
      to: opts[:to],
      text: opts[:text]
    }
    RestClient.get SMSGLOBAL_URL, params: params
  end
end
