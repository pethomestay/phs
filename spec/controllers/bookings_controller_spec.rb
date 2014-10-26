require 'spec_helper'

describe BookingsController, :type => :controller do
	it {expect({get: "bookings/new"}).to route_to(action: "new", controller: "bookings")}
	it {expect({get: 'bookings/result'}).to route_to(action: 'result', controller: 'bookings')}
	it {expect({get: 'bookings/update_transaction'}).to route_to(action: 'update_transaction', controller: 'bookings')}
	it {expect({get: 'bookings/update_message'}).to route_to(action: 'update_message', controller: 'bookings')}
	it {expect({get: 'bookings/1/host_confirm'}).to route_to(action: 'host_confirm', controller: 'bookings', id: '1')}
	it {expect({get: 'bookings/1'}).to route_to(action: 'show', controller: 'bookings', id: '1')}
	it {expect({put: 'bookings/1'}).to route_to(action: 'update', controller: 'bookings', id: '1')}

	before do
		allow(controller).to receive(:authenticate_user!).and_return true
	end

	describe 'GET #new' do
		subject { get :new, enquiry_id: enquiry.id }

		let(:user) { FactoryGirl.create :user_with_pet }
		let(:enquiry) { FactoryGirl.create(:enquiry, homestay: FactoryGirl.create(:homestay), user: user)  }

		before do
			allow(controller).to receive(:current_user).and_return user
      allow(user).to receive_message_chain(:enquiries, :find).with(enquiry.id.to_s) { enquiry }
		end

		it 'should make booking and transaction objects' do
			subject
			expect(response).to render_template :new
			expect(assigns(:booking)).to eq(enquiry.booking)
			expect(assigns(:transaction)).to eq(enquiry.booking.transaction)
		end
	end

	describe 'GET #result' do
		subject { get :result, response_params_from_secure_pay }

		let(:booking) { FactoryGirl.create :booking, transaction: FactoryGirl.create(:transaction) }
		let(:response_params_from_secure_pay) { { timestamp: 'timestamp', summarycode: '00', preauthid: 'pid', txnid: 'tid',
		                                          refid: "transaction_id=#{booking.transaction.id}", restext: '00',
		                                          rescode: '00', fingerprint: 'secure_pay_fingerprint_string' } }

		before do
			secure_pay_fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|transaction_id=#{booking.
					transaction.id}|1.00|timestamp|00"
			allow(Digest::SHA1).to receive(:hexdigest).with(secure_pay_fingerprint_string).and_return('secure_pay_fingerprint_string')
			allow(PetOwnerMailer).to receive(:booking_receipt).and_return double(:mail, deliver: true)
			allow(ProviderMailer).to receive(:owner_confirmed).and_return double(:mail, deliver: true)
		end

		it 'should display successful booking and transaction details' do
			subject
			expect(response).to redirect_to booking_path(booking, confirmed_by: 'guest')
		end
  end

  describe 'GET #guest_cancelled' do
    subject { get :guest_cancelled, id: booking.id }

    let(:user) { FactoryGirl.create :user }
    let(:booking) { FactoryGirl.create :booking, booker: user }

    before { allow(controller).to receive(:current_user).and_return user }

    it 'should render the guest_canceled template' do
      subject
      expect(response).to redirect_to trips_bookings_path
    end
  end

	describe 'GET #index' do
		subject { get :index }

		let(:user) { FactoryGirl.create :user }

		before { allow(controller).to receive(:current_user).and_return user }

		it 'should render the index template' do
			subject
			expect(response).to render_template :index
		end
	end

	describe 'GET #show' do
		subject { get :show, id: booking.id }
		let(:user) { FactoryGirl.create :user }
		let(:booking) {  FactoryGirl.create :booking, booker: user }
		before { allow(controller).to receive(:current_user).and_return user }

		it 'should render the show template' do
			subject
			expect(response).to render_template :show
		end
	end

	describe 'GET #host_confirm' do
		subject { get :host_confirm, id: booking.id }

		let(:user) { FactoryGirl.create :user }
		let(:booking) {  FactoryGirl.create :booking, booker: user }

		before { allow(controller).to receive(:current_user).and_return user }

		it 'should render the host confirm template' do
			subject
			expect(response).to render_template :host_confirm
		end
	end

	describe 'GET #host_message' do
		subject { get :host_message, id: booking.id }

		let(:user) { FactoryGirl.create :user }
		let(:booking) {  FactoryGirl.create :booking, booker: user }

		before { allow(controller).to receive(:current_user).and_return user }

		it 'should redirect to inbox' do
			subject
			expect(response).to redirect_to mailbox_messages_path(booking.mailbox)
		end
	end
end
