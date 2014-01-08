require 'spec_helper'

describe EnquiriesController do
  before do
    controller.stub(:authenticate_user!).and_return true
    Homestay.any_instance.stub(:geocode).and_return true
  end
  describe 'GET #show' do
    subject { get :show, id: 12 }
    let(:enquiry) { stub_model(Enquiry, user: stub_model(User)) }

    context 'when the enquiry homesay belongs to the current user' do
      before do
        controller.stub_chain(:current_user, :homestay, :id).and_return 2
        Enquiry.stub(:find_by_homestay_id_and_id!).and_return enquiry
      end
      it 'should make the enquiry available for rendering' do
        subject
        assigns(:enquiry).should == enquiry
      end

      it 'should make the person ho made the enquiry available for rendering as @user' do
        subject
        assigns(:user).should == enquiry.user
      end

      it 'should render the show template' do
        subject
        response.should render_template :show
      end
    end
  end

  describe 'POST #create' do
    subject { post :create, attributes }
    let(:user) { FactoryGirl.create :user }
    let(:homestay) { FactoryGirl.create :homestay }
    before do
      controller.stub(:current_user).and_return user
      ProviderMailer.stub(:enquiry).and_return mock(:mail, deliver: true)
    end

    context 'with valid attributes' do
      let(:attributes) { {enquiry:{'homestay_id' => homestay.id, 'duration_id' => '3'}} }
      it 'should create an enquiry' do
        expect{ subject }.to change(Enquiry, :count).by(1)
      end
      it 'should set the current user as the person making the enquiry' do
        subject
        assigns(:enquiry).user.should == user
      end
      it 'should redirect back to the homestay' do
        subject
        response.should redirect_to assigns(:enquiry).homestay
      end
    end

    context 'with invalid attributes'
  end

  describe 'PUT #update' do
    subject { put :update, id: enquiry.id, enquiry: attributes }
    before do
      ProviderMailer.stub(:enquiry).and_return mock(:mail, deliver: true)
      controller.stub_chain(:current_user, :homestay, :id).and_return 2
      Enquiry.stub(:find_by_homestay_id_and_id!).and_return enquiry
    end
    let(:enquiry) { FactoryGirl.create :enquiry }

    context 'when the homestay owner can look after the pet' do
      let(:attributes) { {response_id: ReferenceData::Response::ACCEPTED.id} }
      before { PetOwnerMailer.stub(:contact_details).and_return mock(:mail, deliver: true) }
      it 'should send an email to inform the requester' do
        PetOwnerMailer.should_receive(:contact_details)
        subject
      end
    end

    context 'when the homestay owner cannot look after the pet' do
      let(:attributes) { {response_id: ReferenceData::Response::DECLINED.id} }
      before { PetOwnerMailer.stub(:provider_unavailable).and_return mock(:mail, deliver: true) }
      it 'should send an email to inform the requester' do
        PetOwnerMailer.should_receive(:provider_unavailable)
        subject
      end
    end

    context 'when the homestay owner is unsure if they can look after the pet' do
      let(:attributes) { {response_id: ReferenceData::Response::UNDECIDED.id, response_message: 'something'} }
      before { PetOwnerMailer.stub(:provider_undecided).and_return mock(:mail, deliver: true) }
      it 'should send an email to get more information from the requester' do
        PetOwnerMailer.should_receive(:provider_undecided)
        subject
      end
    end
  end
end
