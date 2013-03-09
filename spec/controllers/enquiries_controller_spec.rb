require 'spec_helper'

describe EnquiriesController do
  before { controller.stub(:authenticate_user!).and_return true }
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

      it 'shoudl render the show template' do
        subject
        response.should render_template :show
      end
    end
  end
end
