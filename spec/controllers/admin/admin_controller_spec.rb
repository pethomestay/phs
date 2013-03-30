require 'spec_helper'

describe Admin::AdminController do
  before { controller.stub(:authenticate_user!).and_return true }

  describe 'require_admin!' do
    subject { controller.send(:require_admin!) }
    before { controller.stub(:current_user).and_return user }
    context 'when the current user is an admin' do
      let(:user) { stub_model(User, admin?: true) }
      it 'should return nil' do
        subject.should be_nil
      end
      it 'should not render any template' do
        controller.should_not_receive(:render)
      end
    end
    context 'when the current user is not an admin' do
      let(:user) { stub_model(User, admin?: false) }
      it 'should render the 403 template' do
        controller.should_receive(:render).with(file: "#{Rails.root}/public/403", format: :html, status: 403)
        subject
      end
    end
  end

  describe 'GET #dashboard' do
    subject { get :dashboard }
    before { controller.stub(:require_admin!).and_return true }

    it 'should render the dashboard view' do
      subject
      response.should render_template :dashboard
    end

    it 'should make stas available for rendering' do
      subject
      assigns(:stats).should_not be_nil
    end

    it 'should make recently signed up users available for rendering' do
      User.stub(:last_five).and_return 'last five'
      subject
      assigns(:users).should == 'last five'
    end

    it 'should make recently signed up homestays available for rendering' do
      Homestay.stub(:last_five).and_return 'last five homestays'
      subject
      assigns(:homestays).should == 'last five homestays'
    end
  end
end
