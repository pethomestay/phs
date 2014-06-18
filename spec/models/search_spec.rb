require 'spec_helper'

describe Search do

  before do
    Homestay.any_instance.stub(:geocoding_address).and_return("Melbourne, MB")
  end

  let(:homestay){ FactoryGirl.build(:homestay) }

  it 'should titleize the location' do
    Search.new(location: 'livingstonLane').location.should == 'Livingston Lane'
  end

  it 'should default sort_by to distance' do
    Search.new.sort_by.should == 'distance'
  end

  it 'should default within to a 20km radius' do
    Search.new.within.should == Search::DEFAULT_RADIUS
  end

  describe '#perform' do
    subject { search.perform }
    before { search.stub(:perform_geocode).and_return true }
    context 'when not yet geocoded' do
      let(:search) { Search.new(location: 'Collingwood') }
      it 'should geocode the location' do
        search.should_receive(:perform_geocode)
        subject
      end

    end
    context 'when already geocoded' do
      let(:search) { Search.new(location: 'Collingwood', latitude: 123, longitude: -37 ) }
      it 'should not try to geocode the location' do
        search.should_not_receive(:perform_geocode)
        subject
      end
    end
    context 'after geocoding' do
      let(:search) { Search.new(location: 'Collingwood', latitude: 123, longitude: -37 ) }
      let(:active_scope) { mock(:scope, near: [])}
      before { Homestay.stub(:active).and_return active_scope}
      it 'should retrieve active homestays near the lat/longs provided' do
        Homestay.should_receive(:active)
        active_scope.should_receive(:near).with([search.latitude, search.longitude], search.within, order: search.sort_by)
        subject
      end
    end

    context "when check-in and check-out date is passed" do

      let(:check_in_date){ Date.today }
      let(:search) { Search.new(search_params) }
      let(:active_scope){ double(:scope) }

      before do
        Homestay.stub_chain(:active, :near).and_return(active_scope)
      end

      context "when check out date is absent" do

        let(:search_params){ { location: 'Collingwood', latitude: 123, longitude: -37, check_in_date: check_in_date } }

        it "should retrieve todays available homestays" do
          active_scope.should_receive(:available_between).with(check_in_date, check_in_date + 1.day)
          subject
        end
      end

      context "when check out date is present" do

        let(:search_params){ { location: 'Collingwood', latitude: 123, longitude: -37, check_in_date: check_in_date, check_out_date: check_in_date + 2.days } }

        it "shoud return homestays available between check-in and check-out date" do
          search_params.merge!(check_out_date: check_in_date + 2.days)
          active_scope.should_receive(:available_between).with(check_in_date, check_in_date + 2.days)
          subject
        end
      end

    end
  end
end
