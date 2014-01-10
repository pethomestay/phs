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
		Homestay.any_instance.stub(:geocode).and_return true
	end

	describe 'GET #new' do
		subject { get :new, enquiry_id: enquiry.id }

		let(:user) { stub_model(User) }
		let(:enquiry) { stub_model(Enquiry, user: user, homestay: stub_model(Homestay, cost_per_night: 10)) }

		before do
			controller.stub(:current_user).and_return user
			user.stub_chain(:enquiries, :find).with(enquiry.id.to_s).and_return enquiry
		end

		it 'should make booking and transaction object' do
			subject
			response.should render_template :new
		end
	end
end
