require 'spec_helper'

describe UsersController do
  before do
    controller.stub(:current_user).and_return user
    controller.stub(:authenticate_user!).and_return true
  end
  let(:user) { stub_model(User) }

  describe 'GET #show' do
    subject { get :show }
    it 'should make the user available for rendering' do
      subject
      assigns(:user).should == user
    end

    it 'should render the show template' do
      subject
      response.should render_template :show
    end
  end

  describe "Post #update_calendar" do

    subject{ post :update_calendar }

    before do
      user.stub(:update_calendar)
    end

    it "should pass update calendar message to user" do
      user.should_receive(:update_calendar)
      subject
    end

    it "should give 200 response code" do
      expect(subject.code).to eq("200")
    end

  end
end
