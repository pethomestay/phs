class IosNotifier
  attr_reader :user, :notification

  # Init.
  # @api public
  # @param user [User] The receipient of the notification.
  # @param notification [Hash] An APNs friendly notification hash.
  # @return [IosNotifier]
  def initialize(user, notification)
    @user = user
    @notification = notification
  end

  # Deliver the notification to all active registered devices.
  # @api public
  # @return [Integer] The number of devices that were notified.
  def notify
    devices = user.devices.where(active: true)
    devices.each do |device|
      APN.notify_async(device.token, notification)
    end
    devices.count
  end
end
