require 'rails_helper'

RSpec.describe Device, type: :model do
  describe 'validations' do
    it 'checks presence of token' do
      expect(subject).to validate_presence_of(:token)
    end

    it 'checks uniqueness of token' do
      expect(subject).to validate_uniqueness_of(:token).scoped_to(:user_id)
    end

    it 'checks presence of user ID' do
      expect(subject).to validate_presence_of(:user_id)
    end
  end

  describe '.register' do
    let(:user) { create(:user) }
    let(:device_name) { 'An iPhone' }
    let(:device_token) { '2b11cf43844a2aa2c3bad9559a035fd12499fecd10e558e75f47da39c29d3329' }

    it 'complains if the device token is invalid' do
      expect{ Device.register(user, 'invalid-token', device_name)}.to raise_error(ArgumentError)
    end

    context 'with existing device' do
      it "updates the device name" do
        device = create(:device, user: user, name: 'A Samsung', token: device_token)
        expect(device.name).to eq 'A Samsung'
        resgistered_device = Device.register(user, device_token, device_name)
        expect(resgistered_device.name).to eq 'An iPhone'
      end
    end

    context 'with no existing device' do
      it 'creates a new device' do
        expect{ @device = Device.register(user, device_token, device_name) }.to change(Device, :count).by(1)
        expect(@device).to be_a(Device)
      end
    end
  end
end
