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
    it 'checks and performs the search' do
      subject = HomestaySearch.new(postcode: 2041)
      expect(subject).to receive(:check_params)
      expect(subject).to receive(:check_location)
      expect(subject).to receive(:perform_search)
      subject.perform
    end

    it 'returns the number of results' do
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

end
