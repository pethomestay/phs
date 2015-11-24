require 'rails_helper'

RSpec.describe IosNotifier do
  let(:user) { create(:user) }
  let(:notification) do
    {alert: 'Hello!'}
  end
  let(:subject) { IosNotifier.new(user, notification) }

  describe '#initialize' do
    it 'sets user' do
      expect(subject.user).to eq(user)
    end

    it 'sets notification' do
      expect(subject.notification).to eq(notification.to_options)
    end
  end

  describe '#notify' do
    it 'attempts delivery to all active devices' do
      stranger = create(:user)
      active_device = create(:device, user: user)
      inactive_device = create(:device, user: user, active: false)
      stranger_device = create(:device, user: stranger)
      expect(APN).to receive(:notify_async).with(active_device.token, notification)
      subject.notify
    end

    it 'returns the number of devices notified' do
      active_device = create(:device, user: user)
      inactive_device = create(:device, user: user, active: false)
      allow(APN).to receive(:notify_async)
      expect(subject.notify).to eq 1
    end
  end
end
