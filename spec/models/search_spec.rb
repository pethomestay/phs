require 'spec_helper'

describe Search, :type => :model do

  before do
    allow_any_instance_of(Homestay).to receive(:geocoding_address).and_return("Melbourne, MB")
  end

  let(:homestay){ FactoryGirl.build(:homestay) }

  it 'should titleize the location' do
    expect(Search.new(location: 'livingstonLane').location).to eq('Livingston Lane')
  end

  it 'should default sort_by to distance' do
    expect(Search.new.sort_by).to eq('distance')
  end

  it 'should default within to a 20km radius' do
    expect(Search.new.within).to eq(Search::DEFAULT_RADIUS)
  end

  describe '#perform' do
    subject { search.perform }
    before { allow(search).to receive(:perform_geocode).and_return true }
    context 'when not yet geocoded' do
      let(:search) { Search.new(location: 'Collingwood') }
      it 'should geocode the location' do
        expect(search).to receive(:perform_geocode)
        subject
      end

    end
    context 'when already geocoded' do
      let(:search) { Search.new(location: 'Collingwood', latitude: 123, longitude: -37 ) }
      it 'should not try to geocode the location' do
        expect(search).not_to receive(:perform_geocode)
        subject
      end
    end

    context 'after geocoding' do
      let(:search) { Search.new(location: 'Collingwood', latitude: 123, longitude: -37 ) }
      let(:active_scope) { double(:scope, near: [])}
      let(:homestay_arel) { double(:homestay_arel) }
      
      before do
        allow(Homestay).to receive(:active).and_return active_scope
        allow(active_scope).to receive(:near).and_return(homestay_arel)
        allow(homestay_arel).to receive(:includes).with(:user)
      end

      it 'should retrieve active homestays near the lat/longs provided' do
        expect(Homestay).to receive(:active)
        expect(active_scope).to receive(:near).with([search.latitude, search.longitude], search.within, order: search.sort_by)
        subject
      end
    end

    context "when check-in and check-out date is passed" do

      let(:check_in_date){ Date.today }
      let(:search) { Search.new(search_params) }
      let(:active_scope){ double(:scope) }
      let(:available_scope){ double(:available_scope) }
      let(:homestay_arel){ double(:homestay_arel) }
      let(:search_params){ { location: 'Collingwood', latitude: 123, longitude: -37, check_in_date: check_in_date, check_out_date: check_in_date + 2.days } }

      before do
        expect(Homestay).to receive_message_chain(:active, :near) { active_scope }
        allow(active_scope).to receive(:available_between).and_return(available_scope)
        allow(available_scope).to receive(:not_booked_between).and_return(homestay_arel)
        allow(homestay_arel).to receive(:includes).with(:user)
      end

      it "should include users in the result" do
        expect(homestay_arel).to receive(:includes).with(:user)
        subject
      end

      context "when check out date is absent" do

        let(:search_params){ { location: 'Collingwood', latitude: 123, longitude: -37, check_in_date: check_in_date } }

        it "should retrieve todays available homestays" do
          expect(active_scope).to receive(:available_between).with(check_in_date, check_in_date + 1.day)
          subject
        end

        it "should retrieve todays not booked homestays" do
          expect(available_scope).to receive(:not_booked_between).with(check_in_date, check_in_date + 1.day)
          subject
        end
      end

      context "when check out date is present" do

        it "shoud return homestays available between check-in and check-out date" do
          search_params.merge!(check_out_date: check_in_date + 2.days)
          expect(active_scope).to receive(:available_between).with(check_in_date, check_in_date + 2.days)
          subject
        end

        it "should retrieve todays not booked homestays" do
          expect(available_scope).to receive(:not_booked_between).with(check_in_date, check_in_date + 2.days)
          subject
        end

      end

    end
  end
end
