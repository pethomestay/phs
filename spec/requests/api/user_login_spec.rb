require 'rails_helper'

RSpec.describe 'API: user login', type: :request do
  include_context 'api skeleton'

  let(:password) { 'password' }
  let!(:user) { create(:user, email: 'dave@zero51.com', password: password) }

  describe 'login' do
    context 'credentials are incomplete' do
      it 'returns 400' do
        post tokenised_path('/sessions'), {email: user.email}
        expect(response).to match_error_code(400)
      end
    end

    context 'credentials are incorrect' do
      it 'returns 404' do
        post tokenised_path('/sessions'), {email: user.email, password: 'hello'}
        expect(response).to match_error_code(404)
      end
    end

    context 'credentials are correct' do
      it 'returns the user' do
        post tokenised_path('/sessions'), {email: user.email, password: password}
        expect(response).to be_success
        expect(response).to match_response_schema('session')
        expect(json['user']['id']).to eq(user.id)
      end
    end
  end
end
