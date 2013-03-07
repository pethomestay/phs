require 'spec_helper'

describe ReferenceData::Size do
  describe '#all' do
    it 'should return 5 Sizes' do
      ReferenceData::Size.all.should have(4).items
    end
  end

  describe '#find' do
    it 'should return the Size with the id provided' do
      ReferenceData::Size.find(4).id.should == 4
    end

    it 'should raise RecordNotFound id there is no Size with the id provided' do
      expect{ ReferenceData::Size.find(20) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the Size with the id provided' do
      ReferenceData::Size.find_by_id(4).id.should == 4
    end

    it 'should return nil if there is no Size with the id provided' do
      ReferenceData::Size.find_by_id(20).should be_nil
    end
  end
end
