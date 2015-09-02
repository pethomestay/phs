require 'rails_helper'

RSpec.describe 'API: breeds', type: :request do
  include_context 'api skeleton'

  describe 'list breeds' do
    it 'returns the breeds' do
      get '/breeds?token=12345678'
      expect(response).to be_success
      expect(response).to match_response_schema('breeds')
      expect(json['breeds'][0]['name']).to eq(DOG_BREEDS.first)
    end
  end
end
