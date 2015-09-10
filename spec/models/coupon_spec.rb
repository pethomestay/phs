require 'rails_helper'

RSpec.describe Coupon do
  describe 'validations' do
    it 'checks uniqueness of code'
    it 'checks numericality of discount amount'
    it 'checks coupon limit'
  end

  describe '#used?' do
    context 'booked' do
      it 'returns true'
    end
  end

  describe '#valid_for?' do
    context 'invalid' do
      it 'returns false with used coupon' do
        expect(coupon.valid_for?(user)).to eq false
      end
      it 'returns false with empty coupon'
      it 'returns false with coupon exceeding limit usage'
      it 'returns false when expired'
      it 'returns false when its an admin code'
    end

    context 'valid' do
      it 'returns true'
    end
  end

end
