require 'spec_helper'

describe ReferenceData::Duration do
  describe '#all' do
    it 'should return 11 durations' do
      ReferenceData::Duration.all.should have(11).items
    end
  end

  describe '#find' do
    it 'should return the duration with the id provided' do
      ReferenceData::Duration.find(5).id.should == 5
    end

    it 'should raise RecordNotFound id there is no duration with the id provided' do
      expect{ ReferenceData::Duration.find(20) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the duration with the id provided' do
      ReferenceData::Duration.find_by_id(5).id.should == 5
    end

    it 'should return nil if there is no duration with the id provided' do
      ReferenceData::Duration.find_by_id(20).should be_nil
    end
  end
end