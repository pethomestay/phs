require 'spec_helper'

describe AvailabilityController, :type => :controller do

  let(:user){ FactoryGirl.build(:user, id: 1) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "Get #booking_info" do

    let(:start_date){ Date.today }
    let(:end_date){ Date.today + 4.days }
    let(:booking_info){ [1,2,3] }

    before do
      allow(user).to receive(:booking_info_between).with(start_date, end_date).and_return(booking_info)
    end

    it "should pass booking info message to current user" do
      expect(user).to receive(:booking_info_between).with(start_date, end_date)
      get :booking_info, start: start_date.to_time.to_i, end: end_date.to_time.to_i
    end

    it "should return 200 status codes" do
      get :booking_info, start: start_date.to_time.to_i, end: end_date.to_time.to_i
      expect(response.code).to eq("200")
    end

    it "should return booking info json data" do
      get :booking_info, start: start_date.to_time.to_i, end: end_date.to_time.to_i
      expect(response.body).to eq(booking_info.to_json)
    end

  end


end
