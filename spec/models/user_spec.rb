require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

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
    before :each do
      user.save
    end

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
    before :each do
      user.hex = nil
    end

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
    before :each do
      user.save
    end

    context 'with owned coupons' do
      let(:coupon) { create :coupon, credit_referrer_amount: 10 }
      let!(:booking) { create :booking, coupon: coupon, bookee: user, booker: user }

      it 'returns sum of earnings from owned coupons' do
        user.owned_coupons << coupon

        expect(user.coupon_credits_earned).to eq 10
      end
    end

    context 'without owned coupons' do
      it 'returns 0' do
        expect(user.coupon_credits_earned).to eq 0
      end
    end
  end

  describe '#name' do
    it 'returns first name and last name' do
      expect(user.name).to eq 'Tom LeGrice'
    end
  end

  describe '#update_average_rating' do
    it 'updates average rating' do
      user.save
      expect(user.average_rating).to eq nil
      user.update_average_rating

      expect(user.average_rating).to_not eq nil
    end
  end

  describe '#unlink_from_facebook' do
    let(:facebook_user) { create :user, uid: '123', provider: 'facebook' }

    it 'removes uid and provider from user' do
      facebook_user.unlink_from_facebook
      expect(facebook_user.uid).to eq nil
      expect(facebook_user.provider).to eq nil
    end
  end

  describe '#needs_password?' do
    it 'returns true if provider is blank' do
      user.save
      expect(user.needs_password?).to eq true
    end
  end

  describe '#admin?' do
    context 'when user is admin' do
      it 'returns true' do
        user.admin = true
        expect(user.admin?).to eq true
      end
    end

    context 'when user is on staging' do
      let(:env) { double(staging?: true) }

      it 'returns true' do
        allow(Rails).to receive(:env).and_return env
        expect(user.admin?).to eq true
      end
    end

    context 'when user is on development' do
      let(:env) { double(staging?: false, development?: true) }

      it 'returns true' do
        allow(Rails).to receive(:env).and_return env
        expect(user.admin?).to eq true
      end
    end
  end

  describe '#is_available?' do
    before :each do
      user.save
    end

    context 'with empty options' do
      it 'returns false' do
        expect(user.is_available?).to eq false
      end
    end

    context 'with unavailable dates' do
      it 'returns false' do
        user.unavailable_dates.create(date: DateTime.now)
        expect(user.is_available?(from: DateTime.now, to: DateTime.now)).to eq false
      end
    end

    context 'with available dates' do
      it 'returns true' do
        expect(user.is_available?(from: DateTime.now, to: DateTime.now)).to eq true
      end
    end
  end

  describe '#response_rate_in_percent' do
    pending
  end

  describe '#store_responsiveness_rate' do
    before :each do
      user.save
      allow(user).to receive(:response_rate_in_percent).and_return(10)
    end

    it "saves responsiveness_rate for user" do
      expect(user.responsiveness_rate).to eq nil
      user.store_responsiveness_rate
      expect(user.responsiveness_rate).to eq 10
    end

    it "returns responsiveness_rate of user" do
      expect(user.store_responsiveness_rate).to eq 10
    end
  end

end
