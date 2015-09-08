require 'spec_helper'

RSpec.describe MobileNumber do
  let(:mobile_number) { MobileNumber.new('61-416-291-496') }

  describe '#initialize' do
    it 'sets value' do
      expect(mobile_number.value).to_not eq nil
    end
  end

  describe '#legal?' do
    context 'with legal mobile number' do
      it 'returns true with 10 numbers' do
        mobile_number.value = '0416-123-456' 
        expect(mobile_number.legal?).to eq true
      end

      it 'returns true with 11 numbers' do
        mobile_number.value = '61-416-291-496'
        expect(mobile_number.legal?).to eq true
      end

      it 'returns true with 13 numbers' do
        mobile_number.value = '0061-416-291-496'
        expect(mobile_number.legal?).to eq true
      end
    end

    context 'with illegal mobile number' do
      it "returns false with nil" do
        mobile_number.value = nil
        expect(mobile_number.legal?).to eq false
      end

      it 'returns false with not 10,11,13 numbers' do
        mobile_number.value =  '00061-416-291-496'
        expect(mobile_number.legal?).to eq false
      end
    end
  end

  describe '#to_s' do
    it 'returns value' do
      expect(mobile_number.to_s).to eq '61-416-291-496'
    end
  end
end
