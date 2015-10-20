class Device < ActiveRecord::Base
  belongs_to :user

  validates :token, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true

  # Registers the device to the given user.
  # @api public
  # @param user [User] The device's user.
  # @param device_token [String] The 64-character device token.
  # @param device_name [String] The (optional) device name.
  # @raise [ArgumentError] If the user or device options are invalid.
  # @return [Device] The resgistered device.
  def self.register(user, device_token, device_name = nil)
    device_token.gsub!(/\s/, '')
    raise ArgumentError, 'Invalid token.' if device_token.size != 64
    device = user.devices.where(token: device_token).first
    if device.present?
      device.update_attribute(:name, device_name)
    else
      device = user.devices.create(name: device_name, token: device_token)
    end
    device
  end
end
