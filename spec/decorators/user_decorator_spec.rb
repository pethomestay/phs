require 'rails_helper'

RSpec.describe UserDecorator do
  let(:user) { create :user, :with_address }
  let(:decorator) { UserDecorator.new user }

  describe '#pet_name' do
    context 'with pet' do
      let!(:pet) { create :pet, user: user }

      it 'returns first pet name' do
        expect(decorator.pet_name).to eq pet.name
      end
    end

    context 'without pet' do
      it "returns 'your pets'" do
        expect(decorator.pet_name).to eq 'your pets'
      end
    end
  end

  describe '#pet_names' do
    let!(:pet1) { create :pet, user: user }
    let!(:pet2) { create :pet, user: user }

    it 'returns pet names in sentence' do
      expect(decorator.pet_names).to eq "#{pet2.name} and #{pet1.name}"
    end
  end

  describe '#pet_breed' do
    let!(:pet1) { create :pet, user: user }
    let!(:pet2) { create :pet, user: user }

    it 'returns pet breed in sentence' do
      expect(decorator.pet_breed).to eq "#{pet2.breed} and #{pet1.breed}"
    end

  end

  describe '#pet' do
    let!(:pet) { create :pet, user: user }

    it 'returns first pet' do
      expect(decorator.pet).to eq pet
    end
  end

  describe '#complete_address' do
    it "returns arraged address" do
      expect(decorator.complete_address).to eq "#{user.address_1} Suburb, Melbourne, Australia."
    end
  end

  describe '#stored_card' do
    let(:card) { build :card }

    context 'with selected_stored_card' do
      it 'returns selected stored card' do
        card.save
        expect(decorator.stored_card(card.id, nil)).to eq card
      end
    end

    context 'without selected_stored_card' do
      it 'returns nil without use_stored_card' do
        expect(decorator.stored_card(nil, nil)).to eq nil
      end

      it 'returns first card with use_stored_card' do
        card.user = user
        card.save
        expect(decorator.stored_card(nil, 1)).to eq card
      end
    end
  end
end
