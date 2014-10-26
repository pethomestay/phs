require 'spec_helper'

describe FeedbacksController, :type => :controller do
  let(:enquiry) { stub_model(Enquiry) }
  let(:user) { stub_model(User) }
  before do
    allow_any_instance_of(Homestay).to receive(:geocode).and_return true
    allow(ProviderMailer).to receive(:enquiry).and_return double(:mail, deliver: true)
    allow(Enquiry).to receive(:find_by_id_and_owner_accepted!).and_return enquiry
    allow(controller).to receive(:authenticate_user!).and_return true
    allow(controller).to receive(:current_user).and_return user
  end
  describe 'GET #new' do
    subject { get :new, enquiry_id: 123 }

    context 'when the current user is not an involved party' do
      before do
        allow(enquiry).to receive(:user).and_return stub_model(User)
        allow(enquiry).to receive_message_chain(:homestay, :user => stub_model(User))
      end
      it 'should render a 404' do
        subject
        expect(response.status).to eq(404)
      end
    end

    context 'when the current user is an involved party' do
      before do
        allow(enquiry).to receive(:user).and_return user
        allow(enquiry).to receive_message_chain(:homestay, :user => stub_model(User))
      end
      it 'should render the new template' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    subject { post :create, enquiry_id: enquiry.id, feedback: feedback_params }
    context 'with valid params' do
      let(:feedback_params) { {'rating' => '3', 'review' => 'something' } }
      let(:enquiry) { FactoryGirl.create :enquiry }

      it 'should create a new feedback' do
        expect { subject }.to change(Feedback, :count).by(1)
      end

      it 'should redirect to the my account page' do
        subject
        expect(response).to redirect_to my_account_path
      end
    end

    context 'with invalid params' do
      let(:feedback_params) { {'rating' => nil, 'review' => 'something' } }
      before do
        allow(enquiry).to receive(:user).and_return user
        allow(enquiry).to receive_message_chain(:homestay, :user => stub_model(User))
      end

      it 'should render the new template' do
        subject
        expect(response).to render_template :new
      end
    end
  end
end
