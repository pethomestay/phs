require 'rails_helper'

RSpec.describe Coupon do
  let(:user) { create :user }
  let(:coupon) { build :coupon }

  describe 'validations' do
    it 'checks uniqueness of code' do
      expect(subject).to validate_uniqueness_of(:code)
    end

    it 'checks numericality of discount amount' do
      expect(subject).to validate_numericality_of(:discount_amount)
    end

    it 'checks coupon limit' do
      coupon.coupon_limit = 0
      coupon.save
      expect(coupon.errors[:coupon_limit]).to include "The coupon has already been used"
    end
  end

  describe 'scopes' do
    let(:valid_coupon) { create :coupon, valid_to: DateTime.now + 2.days, coupon_limit: 5 }
    let(:invalid_coupon) { create :coupon, valid_to: DateTime.now - 2.days }

    describe '.valid' do
      it 'returns coupons non-expired coupons within limit' do
        expect(Coupon.valid).to include valid_coupon
        expect(Coupon.valid).to_not include invalid_coupon
      end
    end

    describe '.invalid' do
      it 'returns expired coupons or coupons exceeding limit' do
        expect(Coupon.invalid).to include invalid_coupon
        expect(Coupon.invalid).to_not include valid_coupon
      end
    end
  end

  describe '#used?' do
    context 'booked' do
      it 'returns true' do
        coupon.bookings << FactoryGirl.create(:booking, bookee: user, booker: user)

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
