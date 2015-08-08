require 'rails_helper'

RSpec.describe 'Authentication', type: :request do

  context 'token as param' do
    let!(:token) { create(:api_token, code: '12345678') }

    before(:each) do
      host! 'api.example.com'
    end

    context 'token present' do
      context 'code is correct' do
        it 'returns 200' do
          get '/?token=12345678'
          expect(response).to be_success
          expect(json['hello']).to eq('Woof, woof.')
        end
      end

      context 'code is incorrect' do
        it 'returns 401' do
          get '/?token=1234567'
          expect(response).to match_error_code(401)
        end
      end

      context 'code is for an inactive token' do
        it 'returns 401' do
          token.update_attributes(active: false)
          get '/?token=12345678'
          expect(response).to match_error_code(401)
        end
      end
    end

    context 'token absent' do
      it 'returns 401' do
        get '/'
        expect(response).to match_error_code(401)
      end
    end
  end

end
