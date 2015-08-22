require 'rails_helper'

RSpec.describe Postcode, type: :model do

  describe 'validations' do
    it 'checks presence of postcode' do
      expect(subject).to validate_presence_of(:postcode)
    end

    it 'checks uniqueness of postcode' do
      expect(subject).to validate_uniqueness_of(:postcode)
    end
  end

  describe '#address' do
    subject { build(:postcode, postcode: '2041') }

    it 'provides a geocode-friendly address' do
      expect(subject.address).to eq('2041, Australia')
    end
  end

  describe '.lookup' do
    context 'postcode already exists' do
      it 'returns the postcode' do
        postcode = create(:postcode, postcode: '2041')
        expect{@postcode = Postcode.lookup('2041')}.to_not change(Postcode, :count)
        expect(@postcode.id).to eq(postcode.id)
      end
    end

    context 'postcode does not exist' do
      it 'complains if the passed code is invalid' do
        expect{ Postcode.lookup('10') }.to raise_error(ArgumentError)
      end

      it 'creates a new postcode' do
        expect{@postcode = Postcode.lookup('2041')}.to change(Postcode, :count).by(1)
        expect(@postcode.latitude).to_not be_nil
      end
    end
  end

end
