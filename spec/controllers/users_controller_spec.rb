require 'spec_helper'

describe UsersController, :type => :controller do
  before do
    allow(controller).to receive(:current_user).and_return user
    allow(controller).to receive(:authenticate_user!).and_return true
  end
  let(:user) { stub_model(User) }

  describe 'GET #show' do
    subject { get :show }
    it 'should make the user available for rendering' do
      subject
      expect(assigns(:user)).to eq(user)
    end

    it 'should render the show template' do
      subject
      expect(response).to render_template :show
    end
  end

  describe "Post #update_calendar" do

    subject{ post :update_calendar }

    before do
      allow(user).to receive(:update_calendar)
    end

    it "should pass update calendar message to user" do
      expect(user).to receive(:update_calendar)
      subject
    end

    it "should give 200 response code" do
      expect(subject.code).to eq("200")
    end

  end
end
