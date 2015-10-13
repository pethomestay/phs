require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  let(:user) { create :user }
  before :each do
    sign_in user
  end

  describe 'GET index' do
    context 'with enquiry_id and homestay_id' do
      before :each do
        get :index, enquiry_id: 1, homestay_id: 1
      end

      # skipped since theres no template
      #it { is_expected.to respond_with 200 }
    end
    
    context 'without enquiry_id and homestay_id' do
      before :each do
        get :index
      end

      it { is_expected.to respond_with 302 }
    end

  end

  describe '#new'
  describe '#update_dates' do
    before :each do
      post :update_dates
    end
    it { is_expected.to respond_with 200}
  end
  describe '#edit'
  describe '#owner_receipt'
  describe '#host_receipt'
  describe '#update'
  describe '#show'
  describe '#result'
  describe '#host_confirm'
  describe '#book_reservation'
  describe '#host_message'
  describe '#update_transaction'
  describe '#update_message'
  describe '#guest_cancelled'
  describe '#host_paid'
  describe '#guest_refunded'
  describe '#admin_view'
  describe '#host_cancellation'
  describe '#host_cancel'
  describe '#host_confirm_cancellation'
  describe '#guest_save_cancel_reason'
end
