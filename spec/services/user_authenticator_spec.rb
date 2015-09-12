require 'rails_helper'

RSpec.describe UserAuthenticator do
  let(:auth) { double(:auth, provider: "facebook", uid: "12345") }
  let(:user) { build :user, provider: "facebook", uid: "12345" }
  let(:authenticator) { UserAuthenticator.new(user, auth) }
  let(:graph) do 
    double(:graph, 
            get_object: { 
              'email' => 'lalala@example.com', 
              'age_range' => { 'min' => 10, 'max' => 20 },
              'first_name' => 'first name',
              'last_name' => 'last name',
              'location' => { 'name' => 'Melbourne' }
            }, 
            get_connections: [{ 'user_location' => 1}]
          )
  end

  before :each do
    allow(authenticator).to receive(:graph).and_return graph
  end

  describe '#initialize' do
    it 'sets current_user' do
      expect(authenticator.current_user).to_not eq nil
    end

    it 'sets auth' do
      expect(authenticator.auth).to_not eq nil
    end
  end

  describe '#user' do
    context 'with given user' do
      it 'returns given user' do
        expect(authenticator.user).to eq user
      end
    end

    context 'without given user' do
      it 'returns user from auth' do
        user.save
        authenticator.current_user = nil
        expect(authenticator.user).to eq user
      end

      it 'returns user from graph' do
        user.update_attributes(email: 'lalala@example.com', provider: "facebook", uid: nil)
        authenticator.current_user = nil
        expect(authenticator.user).to eq user
      end

      it 'returns a new user' do
        user.update_attributes(email: nil, uid: nil)
        authenticator.current_user = nil
        expect(authenticator.user).to_not be_persisted
        expect(authenticator.user.email).to eq "lalala@example.com"
      end
    end
  end

  describe '#authenticate' do
    context 'with non-persisted user' do
      it 'sets user details' do
        authenticator.authenticate
        expect(authenticator.user.email).to eq 'lalala@example.com'
        expect(authenticator.user.first_name).to eq 'first name'
        expect(authenticator.user.last_name).to eq 'last name'
      end

      it 'sets user location' do
        authenticator.authenticate
        expect(authenticator.user.facebook_location).to eq 'Melbourne'
      end

      it 'sets user age' do
        authenticator.authenticate
        expect(authenticator.user.age_range_min).to eq 10
        expect(authenticator.user.age_range_max).to eq 20
      end
    end

    context 'with blank provider' do
      before :each do
        user.provider = nil
      end

      it 'sets provider for user' do
        authenticator.authenticate
        expect(authenticator.user.provider).to_not eq nil
      end

      it 'sets uid for user' do
        user.uid = nil
        authenticator.authenticate
        expect(authenticator.user.uid).to_not eq nil
      end
    end

    it 'persists user' do
      authenticator.authenticate
      expect(authenticator.user).to be_persisted
    end

    it 'returns user' do
      expect(authenticator.authenticate).to eq user
    end
  end
end
