require 'rails_helper'

RSpec.describe 'Sessions', type: :request do

  let(:password) { 'password' }
  let!(:token) { create(:api_token, code: '12345678') }
  let!(:user) { create(:user, email: 'dave@zero51.com', password: password) }

  before(:each) do
    host! 'api.example.com'
  end

  describe 'login' do
    context 'credentials are incomplete' do
      it 'returns 400' do
        post '/sessions?token=12345678', {email: user.email}
        expect(response).to match_error_code(400)
      end
    end

    context 'credentials are incorrect' do
      it 'returns 404' do
        post '/sessions?token=12345678', {email: user.email, password: 'hello'}
        expect(response).to match_error_code(404)
      end
    end

    context 'credentials are correct' do
      it 'returns the user' do
        post '/sessions?token=12345678', {email: user.email, password: password}
        expect(response).to be_success
        expect(response).to match_response_schema('session')
        expect(json['user']['id']).to eq(user.id)
      end
    end
  end

end
