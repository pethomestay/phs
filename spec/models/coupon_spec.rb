require 'rails_helper'

RSpec.describe Coupon do
  let(:user) { create :user }
  let(:coupon) { build :coupon }

  describe 'validations' do
    it 'checks uniqueness of code'
    it 'checks numericality of discount amount'
    it 'checks coupon limit'
  end

  describe '#used?' do
    context 'booked' do
      it 'returns true' do
        expect(coupon.used?).to eq true
      end
    end
  end

  describe '#valid_for?' do
    context 'invalid' do
      it 'returns false with user used coupon' do
        user.used_coupons << coupon
        expect(coupon.valid_for?(user)).to eq false
      end

      it 'returns false with empty user' do
        expect(coupon.valid_for?(nil)).to eq false
      end

      it 'returns false with coupon exceeding limit usage' do
        coupon.coupon_limit = 0
        expect(coupon.valid_for?(user)).to eq false
      end

      it 'returns false when expired' do
        coupon.valid_to = DateTime.now - 2.days
        expect(coupon.valid_for?(user)).to eq false
      end

      it 'returns false when its an admin code' do
        coupon.admin_mass_code = true
        expect(coupon.valid_for?(user)).to eq false
      end
    end

    context 'valid' do
      it 'returns true' do
        expect(coupon.valid_for?(user)).to eq true
      end
    end
  end

end
