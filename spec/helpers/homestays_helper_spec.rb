require 'spec_helper'

describe HomestaysHelper do
  describe '#my_homestay?' do
    subject { helper.my_homestay? homestay }
    before do
      helper.stub(:current_user).and_return user
    end

    context 'when there is no current user' do
      let(:user) { nil }
      let(:homestay) { nil }
      it { should be_false }
    end

    context 'when the current user owns the homestay' do
      let(:user) { mock(:user, homestay: homestay)}
      let(:homestay) { mock(:homestay) }
      it { should be_true }
    end

    context 'when the current user does not own the homestay' do
      let(:user) { mock(:user, homestay: nil)}
      let(:homestay) { mock(:homestay) }
      it { should be_false }
    end
  end
end