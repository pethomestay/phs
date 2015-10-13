require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build :user }

    it 'checks presence of first_name' do
      expect(subject).to validate_presence_of(:first_name)
    end

    it 'checks presence of last_name' do
      expect(subject).to validate_presence_of(:last_name)
    end

    it 'checks presence of email' do
      expect(subject).to validate_presence_of(:email)
    end

    it 'confirms acceptance for accept_house_rules' do
      expect(subject).to validate_acceptance_of(:accept_house_rules)
    end

    it 'confirms acceptance for accept_terms' do
      expect(subject).to validate_acceptance_of(:accept_terms)
    end

    it 'checks uniqueness of hex' do
      expect(subject).to validate_uniqueness_of(:hex).allow_blank
    end
  end

  describe 'scopes' do
    describe '.active' do
      let!(:inactive_user) { create :user, active: false }
      let!(:active_user) { create :user, active: true }

      it 'returns active users' do
        expect(User.active).to_not include(inactive_user)
        expect(User.active).to include(active_user)
      end
    end

    describe '.last_five' do
      let!(:users) { create_list :user, 6 }

      it 'returns last 5 created users' do
        expect(User.last_five.count).to eq 5
        expect(User.last_five).to_not include users.first
      end
    end
  end

  describe '#generate_referral_code' do
    let(:user) { create :user }

    context 'with forced creation' do
      it 'creates owned_coupons for user' do
        expect{ user.generate_referral_code(true) }.to change(user.owned_coupons, :count).by 1
      end
    end

    context 'without forced creation' do
      it 'does not created owned coupons' do
        expect{ user.generate_referral_code }.to_not change(user.owned_coupons, :count)
      end
    end
  end

  describe '#generate_hex' do
    let(:user) { build :user, hex: nil }

    context 'without hex' do
      it 'creates hex' do
        expect(user.hex).to eq nil
        user.generate_hex
        expect(user.hex).to_not eq nil
      end
    end

    context 'with hex' do
      it 'does not create hex' do
        user.hex = 'ABC'
        user.generate_hex
        expect(user.hex).to eq 'ABC'
      end
    end
  end

  describe '#coupon_credits_earned' do
    pending 
  end

  describe '#name' do
    let(:user) { build :user }

    it 'returns first name and last name' do
      expect(user.name).to eq 'Tom LeGrice'
    end
  end

  describe '#validate_code' do
    pending
  end

  describe '#update_average_rating' do
    let(:user) { create :user }

    it 'updates average rating' do
      expect(user.average_rating).to eq nil
      user.update_average_rating

      expect(user.average_rating).to_not eq nil
    end
  end

  describe '#find_or_create_booking_by' do
    pending
  end

  describe '#find_or_create_transaction_by' do
    pending
  end

  describe '#find_stored_card_id' do
    pending
  end

  describe '#unlink_from_facebook' do
    let(:user) { create :user, uid: '123', provider: 'facebook' }

    it 'removes uid and provider from user' do
      user.unlink_from_facebook
      expect(user.uid).to eq nil
      expect(user.provider).to eq nil
    end
  end

  describe '#needs_password?' do
    let(:user) { create :user, provider: nil }

    it 'returns true if provider is blank' do
      expect(user.needs_password?).to eq true
    end
  end

  describe '#update_without_password' do
    pending
  end

end
