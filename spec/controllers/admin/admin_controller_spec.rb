require 'spec_helper'

describe Admin::AdminController do
  before do
    controller.stub(:authenticate_user!).and_return true
    controller.stub(:require_admin!).and_return true
  end

  describe 'GET #dashboard' do
    subject { get :dashboard }

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
