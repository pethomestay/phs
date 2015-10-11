require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe 'GET index' do
    before :each do
      get :index
    end

    #it { is_expected.to respond_with 200 }
  end

  describe '#new'
  describe '#update_dates'
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
