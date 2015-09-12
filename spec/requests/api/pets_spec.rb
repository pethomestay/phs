require 'rails_helper'

RSpec.describe 'API: pets', type: :request do
  include_context 'api skeleton'

  let(:user) { create(:user) }
  let(:pet_params) do
    {
      name: 'Henry',
      type: 1,
      breed: 'Cocker Spaniel',
      age: 9,
      sex: 1,
      size: 1,
      energy_level: 1,
      personality: ['Affectionate', 'Happy']
    }
  end

  describe 'list pets' do
    it_behaves_like 'an authorised user', '/pets', :get

    it "returns the user's pets" do
      stranger = create(:user)
      create(:pet, name: 'Henry', user: user)
      create(:pet, name: 'Charlie', user: user)
      create(:pet, name: 'Fideo', user: stranger)
      get tokenised_path('/pets', user)
      expect(response).to be_success
      expect(response).to match_response_schema('pets')
      expect(json['pets'].size).to eq(2)
      expect(json['pets'][0]['name']).to eq('Henry')
    end
  end

  describe 'create pet' do
    it_behaves_like 'an authorised user', '/pets', :post

    context 'with valid params' do
      it 'succeeds' do
        post tokenised_path('/pets', user), { pet: pet_params }
        expect(response).to be_success
        expect(response).to match_response_schema('pet')
        expect(json['pet']['name']).to eq(pet_params[:name])
      end
    end

    context 'with invalid params' do
      it 'returns 400' do
        post tokenised_path('/pets', user), { pet: pet_params.except(:name) }
        expect(response).to match_error_code(400)
      end
    end
  end
end
