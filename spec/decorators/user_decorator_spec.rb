require 'rails_helper'

RSpec.describe UserDecorator do
  let(:user) { create :user }
  let(:decorator) { UserDecorator.new user }

  describe '#pet_name' do
    context 'with pet' do
      let!(:pet) { create :pet, user: user }

      it 'returns first pet name' do
        expect(decorator.pet_name).to eq pet.name
      end
    end

    context 'without pet' do
      it "returns 'your pets'"
    end
  end

  describe '#pet_names' do
    it 'returns pet names in sentence'
  end

  describe '#pet_breed' do
    it 'returns pet breed in sentence'
  end

  describe '#pet' do
    it 'returns first pet'
  end
end
