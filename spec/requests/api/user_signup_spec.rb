require 'rails_helper'

RSpec.describe 'API: user signup', type: :request do
  include_context 'api skeleton'

  let(:user_params) do
    {
      first_name: 'Tom',
      last_name: 'LeGrice',
      email: 'tom@pethomestay.com',
      password: 'puppies'
    }
  end

  describe 'signup' do
    context 'credentials are incorrect' do
      it 'returns 400' do
        post tokenised_path('/users'), user_params
        expect(response).to match_error_code(400)
      end
    end

    context 'credentials are incomplete' do
      it 'returns 400' do
        post tokenised_path('/users'), {user: user_params.except(:first_name)}
        expect(response).to match_error_code(400)
      end
    end

    context 'credentials are complete' do
      it 'returns the user' do
        post tokenised_path('/users'), {user: user_params}
        expect(response).to be_success
        expect(response).to match_response_schema('user')
        expect(json['user']['email']).to eq(user_params[:email])
      end
    end
  end
end
