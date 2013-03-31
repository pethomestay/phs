require 'spec_helper'

describe FeedbacksController do
  let(:enquiry) { stub_model(Enquiry) }
  let(:user) { stub_model(User) }
  before do
    Homestay.any_instance.stub(:geocode).and_return true
    ProviderMailer.stub(:enquiry).and_return mock(:mail, deliver: true)
    Enquiry.stub(:find_by_id_and_owner_accepted!).and_return enquiry
    controller.stub(:authenticate_user!).and_return true
    controller.stub(:current_user).and_return user
  end
  describe 'GET #new' do
    subject { get :new, enquiry_id: 123 }

    context 'when the current user is not an involved party' do
      before do
        enquiry.stub(:user).and_return stub_model(User)
        enquiry.stub_chain(:homestay, :user).and_return stub_model(User)
      end
      it 'should render a 404' do
        subject
        response.status.should == 404
      end
    end

    context 'when the current user is an involved party' do
      before do
        enquiry.stub(:user).and_return user
        enquiry.stub_chain(:homestay, :user).and_return stub_model(User)
      end
      it 'should render the new template' do
        subject
        response.should render_template :new
      end
    end
  end

  describe 'POST #create' do
    subject { post :create, enquiry_id: enquiry.id, feedback: feedback_params }
    context 'with valid params' do
      let(:feedback_params) { {'rating' => '3', 'review' => 'something' } }
      let(:enquiry) { Enquiry.make! }

      it 'should create a new feedback' do
        expect { subject }.to change(Feedback, :count).by(1)
      end

      it 'should redirect to the my account page' do
        subject
        response.should redirect_to my_account_path
      end
    end

    context 'with invalid params' do
      let(:feedback_params) { {'rating' => nil, 'review' => 'something' } }
      before do
        enquiry.stub(:user).and_return user
        enquiry.stub_chain(:homestay, :user).and_return stub_model(User)
      end

      it 'should render the new template' do
        subject
        response.should render_template :new
      end
    end
  end
end
