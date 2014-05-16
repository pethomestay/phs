require 'spec_helper'

describe BookingsController do
	it {{get: "bookings/new"}.should route_to(action: "new", controller: "bookings")}
	it {{get: 'bookings/result'}.should route_to(action: 'result', controller: 'bookings')}
	it {{get: 'bookings/update_transaction'}.should route_to(action: 'update_transaction', controller: 'bookings')}
	it {{get: 'bookings/update_message'}.should route_to(action: 'update_message', controller: 'bookings')}
	it {{get: 'bookings/1/host_confirm'}.should route_to(action: 'host_confirm', controller: 'bookings', id: '1')}
	it {{get: 'bookings/1'}.should route_to(action: 'show', controller: 'bookings', id: '1')}
	it {{put: 'bookings/1'}.should route_to(action: 'update', controller: 'bookings', id: '1')}

	before do
		controller.stub(:authenticate_user!).and_return true
	end

	describe 'GET #new' do
		subject { get :new, enquiry_id: enquiry.id }

		let(:user) { FactoryGirl.create :user_with_pet }
		let(:enquiry) { FactoryGirl.create(:enquiry, homestay: FactoryGirl.create(:homestay), user: user)  }

		before do
			controller.stub(:current_user).and_return user
			user.stub_chain(:enquiries, :find).with(enquiry.id.to_s).and_return enquiry
		end

		it 'should make booking and transaction objects' do
			subject
			response.should render_template :new
			assigns(:booking).should == enquiry.booking
			assigns(:transaction).should == enquiry.booking.transaction
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
			Digest::SHA1.stub(:hexdigest).with(secure_pay_fingerprint_string).and_return('secure_pay_fingerprint_string')
			PetOwnerMailer.stub(:booking_receipt).and_return mock(:mail, deliver: true)
			ProviderMailer.stub(:owner_confirmed).and_return mock(:mail, deliver: true)
		end

		it 'should display successful booking and transaction details' do
			subject
			response.should redirect_to booking_path(booking, confirmed_by: 'guest')
		end
  end

  describe 'GET #guest_canceled' do
    subject { get :guest_canceled, id: booking.id }

    let(:user) {FactoryGirl.create :user }
    let(:booking) {  FactoryGirl.create :booking, booker: user }

    before { controller.stub(:current_user).and_return user }

    it 'should render the guest_canceled template' do
      subject
      response.should render_template :guest_canceled
    end

  end

	describe 'GET #index' do
		subject { get :index }

		let(:user) { FactoryGirl.create :user }

		before { controller.stub(:current_user).and_return user }

		it 'should render the index template' do
			subject
			response.should render_template :index
		end
	end

	describe 'GET #show' do
		subject { get :show, id: booking.id }
		let(:user) { FactoryGirl.create :user }
		let(:booking) {  FactoryGirl.create :booking, booker: user }
		before { controller.stub(:current_user).and_return user }

		it 'should render the show template' do
			subject
			response.should render_template :show
		end
	end

	describe 'GET #host_confirm' do
		subject { get :host_confirm, id: booking.id }

		let(:user) { FactoryGirl.create :user }
		let(:booking) {  FactoryGirl.create :booking, booker: user }

		before { controller.stub(:current_user).and_return user }

		it 'should render the host confirm template' do
			subject
			response.should render_template :host_confirm
		end
	end

	describe 'GET #host_message' do
		subject { get :host_message, id: booking.id }

		let(:user) { FactoryGirl.create :user }
		let(:booking) {  FactoryGirl.create :booking, booker: user }

		before { controller.stub(:current_user).and_return user }

		it 'should redirect to inbox' do
			subject
			response.should redirect_to mailbox_messages_path(booking.mailbox)
		end
	end
end
