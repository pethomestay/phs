require 'spec_helper'

describe HomestaysHelper, :type => :helper do
  describe '#my_homestay?' do
    subject { helper.my_homestay? homestay }
    before do
      allow(helper).to receive(:current_user).and_return user
    end

    context 'when there is no current user' do
      let(:user) { nil }
      let(:homestay) { nil }
      it { is_expected.to be_falsey }
    end

    context 'when the current user owns the homestay' do
      let(:user) { double(:user, homestay: homestay)}
      let(:homestay) { double(:homestay) }
      it { is_expected.to be_truthy }
    end

    context 'when the current user does not own the homestay' do
      let(:user) { double(:user, homestay: nil)}
      let(:homestay) { double(:homestay) }
      it { is_expected.to be_falsey }
    end
  end
end