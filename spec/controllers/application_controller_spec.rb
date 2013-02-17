require 'spec_helper'

describe ApplicationController do

  describe '#after_sign_in_path_for' do
    subject { controller.after_sign_in_path_for(user) }
    
    context 'when a redirect path is present' do
      let(:user) { nil }
      before do
        controller.stub(:params).and_return({redirect_path: 'turnip_town'})
      end
      it 'should return that redirect path' do
        subject.should == 'turnip_town'
      end
    end

    context 'when the user has no homestay or pets' do
      let(:user) { mock(:user, homestay: nil, pets: nil) }

      it 'should return the welcome path' do
        subject.should == welcome_path
      end

      it 'should maintain the signup path if it is present' do
        controller.stub(:params).and_return( {signup_path: 'sign me up'})
        subject.should == welcome_path(signup_path: 'sign me up')
      end
    end

    context 'when the user has either a pet or a homestay' do
      let(:user) { mock(:user, homestay: stub_model(Homestay), pets: nil) }

      it 'should return the users account path' do
        subject.should == my_account_path
      end
    end
  end

end