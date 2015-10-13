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

      it "returns last 5 created users" do
        expect(User.last_five.count).to eq 5
        expect(User.last_five).to_not include users.first
      end
    end
  end

  describe "#generate_referral_code" do
    let(:user) { create :user }

    context "with forced creation" do
      it "creates owned_coupons for user" do
        expect{ user.generate_referral_code(true) }.to change(user.owned_coupons, :count).by 1
      end
    end

    context "without forced creation" do
      it "does not created owned coupons" do
        expect{ user.generate_referral_code }.to_not change(user.owned_coupons, :count)
      end
    end
  end
end
