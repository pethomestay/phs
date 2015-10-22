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

      context 'with device params' do
        let(:params) do
          {
            email: user.email,
            password: password,
            device: {
              name: 'iPhone',
              token: '12345678'
            }
          }
        end

        context 'existing device present' do
          it 'set the device to active' do
            device = create(:device, user: user, token: '12345678', active: false)
            post tokenised_path('/sessions'), params
            device.reload
            expect(device.active).to eq true
          end
        end

        context 'existing device absent' do
          it 'creates a new device' do
            expect{ post tokenised_path('/sessions'), params }.to change(Device, :count).by(1)
          end
        end
      end

      context 'with OAuth params' do
        it 'allows a blank password' do
          post tokenised_path('/sessions'), {
            email: user.email,
            oauth: {
              provider: 'facebook',
              token: '12345678'
            }
          }
          expect(response).to be_success
          expect(response).to match_response_schema('session')
          expect(json['user']['id']).to eq(user.id)
        end

        it 'updates the user OAuth details' do
          post tokenised_path('/sessions'), {
            email: user.email,
            password: password,
            oauth: {
              provider: 'facebook',
              token: '12345678'
            }
          }
          user.reload
          expect(user.provider).to eq 'facebook'
          expect(user.uid).to eq '12345678'
        end
      end
    end
  end
end
