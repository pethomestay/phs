require 'rails_helper'

RSpec.describe HomestaySearch do

  describe '#initialize' do
    it 'stores the passed params' do
      params = {postcode: 2041}
      subject = HomestaySearch.new(params)
      expect(subject.params).to eq(params)
    end
  end

  describe '#perform' do
    let(:results) { [Homestay.new, Homestay.new] }
    subject { HomestaySearch.new(postcode: 2041) }

    before(:each) do
      allow(subject).to receive(:results).and_return(results)
    end

    it 'checks and performs the search' do
      expect(subject).to receive(:check_params)
      expect(subject).to receive(:check_location)
      expect(subject).to receive(:perform_search)
      expect(subject).to receive(:augment_search)
      subject.perform
    end

    it 'returns the number of results' do
      expect(subject.perform).to eq(results.size)
    end
  end

  describe '#check_params' do
    subject { HomestaySearch.new }

    it 'complains if the params are invalid' do
      params = {latitude: 1}
      subject.params = params
      expect{ subject.check_params }.to raise_error(ArgumentError)
    end

    it 'is silent if the postcode is present' do
      params = {postcode: 2041}
      subject.params = params
      expect{ subject.check_params }.to_not raise_error
    end

    it 'is silent if the latitude and longitude is present' do
      params = {latitude: 1, longitude: 1}
      subject.params = params
      expect{ subject.check_params }.to_not raise_error
    end
  end

  describe '#check_location' do
    subject { HomestaySearch.new }

    it 'complains if the postcode is invalid' do
      params = {postcode: 20}
      subject.params = params
      expect{ subject.check_location }.to raise_error(ArgumentError)
    end

    it 'is silent if the location is OK' do
      params = {postcode: 2041}
      subject.params = params
      expect{ subject.check_location }.to_not raise_error
    end
  end

  describe '#perform_search' do
    subject { HomestaySearch.new(postcode: '2041') }

    it 'initialises a new Search' do
      search = double('search').as_null_object
      expect(Search).to receive(:new).with(postcode: '2041').and_return(search)
      subject.perform_search
    end

    it 'sets the country to Australia' do
      search = double('search').as_null_object
      allow(Search).to receive(:new).and_return(search)
      expect(search).to receive('country=').with('Australia')
      subject.perform_search
    end

    it 'triggers the search and uses the algorithm' do
      search = double('search').as_null_object
      results = [double('result').as_null_object]
      allow(Search).to receive(:new).and_return(search)
      expect(search).to receive(:populate_list).and_return(results)
      expect(Search).to receive(:algorithm).with(results)
      subject.perform_search
    end

    it 'stores the results' do
      search = double('search').as_null_object
      results = [double('result').as_null_object]
      allow(Search).to receive(:new).and_return(search)
      allow(search).to receive(:populate_list).and_return(results)
      subject.perform_search
      expect(subject.results).to eq(results)
    end
  end

  describe '#augment_search' do
    let(:results) { [Homestay.new, Homestay.new] }
    subject { HomestaySearch.new(postcode: '2041') }

    before(:each) do
      allow(subject).to receive(:results).and_return(results)
      allow(Geocoder::Calculations).to receive(:distance_between).and_return(123)
    end

    it 'stores the position for each result' do
      augmented_results = subject.augment_search
      expect(augmented_results[0].position).to eq(1)
      expect(augmented_results[1].position).to eq(2)
    end

    it 'stores the distance for each result' do
      augmented_results = subject.augment_search
      expect(augmented_results[0].distance).to eq(123)
      expect(augmented_results[1].distance).to eq(123)
    end
  end

end
