require 'spec_helper'

describe ReferenceData::Response do
  describe '#all' do
    it 'should return 5 Responses' do
      ReferenceData::Response.all.should have(4).items
    end
  end

  describe '#find' do
    it 'should return the Response with the id provided' do
      ReferenceData::Response.find(4).id.should == 4
    end

    it 'should raise RecordNotFound id there is no Response with the id provided' do
      expect{ ReferenceData::Response.find(5) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the Response with the id provided' do
      ReferenceData::Response.find_by_id(4).id.should == 4
    end

    it 'should return nil if there is no Response with the id provided' do
      ReferenceData::Response.find_by_id(5).should be_nil
    end
  end
end
