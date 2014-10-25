require 'spec_helper'

describe ApplicationController, :type => :controller do
  login_admin_user
  describe '#is_current_user_admin' do


    context 'when current_user is not set or is not admin' do
      before do
        sign_out subject.current_admin_user
      end
      it "should not be admin by default"   do
        expect(subject.current_admin_user).to be_nil
      end
    end

    context 'when current_user is an admin' do

      it "should be admin"   do
        expect(subject.current_admin_user).not_to be_nil
      end
    end
  end

  describe '#after_sign_in_path_for' do
    subject { controller.after_sign_in_path_for(user) }

    context 'when a redirect path is present' do
      let(:user) { nil }
      before do
        allow(controller).to receive(:params).and_return({redirect_path: 'turnip_town'})
      end
      it 'should return that redirect path' do
        expect(subject).to eq('turnip_town')
      end
    end

    context 'when the user has no homestay or pets' do
      let(:user) { double(:user, homestay: nil, pets: nil) }

      it 'should return the welcome path' do
        expect(subject).to eq(welcome_path)
      end

      it 'should maintain the signup path if it is present' do
        allow(controller).to receive(:params).and_return( {signup_path: 'sign me up'})
        expect(subject).to eq(welcome_path(signup_path: 'sign me up'))
      end
    end

    context 'when the user has a homestay' do
      let(:user) { double(:user, homestay: stub_model(Homestay), pets: nil) }

      it('should return the mailbox path') { expect(subject).to eq(host_path) }
    end

    context 'when the user has a pets' do
      let(:user) { double(:user, homestay: nil, pets: double(:pets)) }

      it('should return the mailbox path') { expect(subject).to eq(guest_path)  }
    end
  end

end
