require 'spec_helper'

describe ReferenceData::Duration, :type => :model do
  describe '#all' do
    it 'should return 11 durations' do
      expect(ReferenceData::Duration.all.size).to eq(11)
    end
  end

  describe '#find' do
    it 'should return the duration with the id provided' do
      expect(ReferenceData::Duration.find(11).id).to eq(11)
    end

    it 'should raise RecordNotFound id there is no duration with the id provided' do
      expect{ ReferenceData::Duration.find(20) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the duration with the id provided' do
      expect(ReferenceData::Duration.find_by_id(5).id).to eq(5)
    end

    it 'should return nil if there is no duration with the id provided' do
      expect(ReferenceData::Duration.find_by_id(20)).to be_nil
    end
  end
end
