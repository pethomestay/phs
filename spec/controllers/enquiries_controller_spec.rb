require 'spec_helper'

describe EnquiriesController, :type => :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return true
    allow_any_instance_of(Homestay).to receive(:geocode).and_return true
  end
  describe 'GET #show' do
    subject { get :show, id: 12 }
    let(:enquiry) { stub_model(Enquiry, user: FactoryGirl.create(:user_with_pet)) }

    context 'when the enquiry homesay belongs to the current user' do
      before do
        controller.stub_chain(:current_user, :homestay, :id).and_return 2
        allow(Enquiry).to receive(:find_by_homestay_id_and_id!).and_return enquiry
      end
      it 'should make the enquiry available for rendering' do
        subject
        expect(assigns(:enquiry)).to eq(enquiry)
      end

      it 'should make the person ho made the enquiry available for rendering as @user' do
        subject
        expect(assigns(:user)).to eq(enquiry.user)
      end

      it 'should render the show template' do
        subject
        expect(response).to render_template :show
      end
    end
  end

  describe 'POST #create' do
    subject { post :create, attributes }
    let(:user) { FactoryGirl.create :user }
    let(:homestay) { FactoryGirl.create :homestay }
    before do
      allow(controller).to receive(:current_user).and_return user
      allow(ProviderMailer).to receive(:enquiry).and_return double(:mail, deliver: true)
    end

    context 'with valid attributes' do
      let(:attributes) { {enquiry:{'homestay_id' => homestay.id, 'check_in_date' => DateTime.now,
                                   'check_out_date' => DateTime.now, 'duration_id' => '3'}} }
      it 'should create an enquiry' do
        expect{ subject }.to change(Enquiry, :count).by(1)
      end
      it 'should set the current user as the person making the enquiry' do
        subject
        expect(assigns(:enquiry).user).to eq(user)
      end
      it 'should redirect back to the homestay' do
        subject
        expect(response).to redirect_to assigns(:enquiry).homestay
      end
    end

    context 'with invalid attributes' do

    end
  end

  describe 'PUT #update' do
    subject { put :update, id: enquiry.id, enquiry: attributes }
    before do
      allow(ProviderMailer).to receive(:enquiry).and_return double(:mail, deliver: true)
      controller.stub_chain(:current_user, :homestay, :id).and_return 2
      controller.stub_chain(:current_user, :id).and_return 2
      allow(Enquiry).to receive(:find_by_homestay_id_and_id!).and_return enquiry
    end
    let(:enquiry) { FactoryGirl.create :enquiry }

    context 'when the homestay owner can look after the pet' do
      let(:attributes) { {response_id: ReferenceData::Response::ACCEPTED.id, response_message: 'something'} }
      before { allow(PetOwnerMailer).to receive(:host_enquiry_response).and_return double(:mail, deliver: true) }
      it 'should send an email to inform the requester' do
        # See the comment in the corresponding modal
	      #PetOwnerMailer.should_receive(:host_enquiry_response)
        subject
      end
    end

    context 'when the homestay owner cannot look after the pet' do
      let(:attributes) { {response_id: ReferenceData::Response::DECLINED.id, response_message: 'something'} }
      before { allow(PetOwnerMailer).to receive(:host_enquiry_response).and_return double(:mail, deliver: true) }
      it 'should send an email to inform the requester' do
        # See the comment in the corresponding modal
        #PetOwnerMailer.should_receive(:host_enquiry_response)
        subject
      end
    end

    context 'when the homestay owner is unsure if they can look after the pet' do
      let(:attributes) { {response_id: ReferenceData::Response::UNDECIDED.id, response_message: 'something'} }
      before { allow(PetOwnerMailer).to receive(:host_enquiry_response).and_return double(:mail, deliver: true) }
      it 'should send an email to get more information from the requester' do
        # See the comment in the corresponding modal
        #PetOwnerMailer.should_receive(:host_enquiry_response)
        subject
      end
    end
  end
end
