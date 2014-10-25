require 'spec_helper'

describe ReferenceData::Sex, :type => :model do
  describe '#all' do
    it 'should return 5 Sexs' do
      expect(ReferenceData::Sex.all.size).to eq(4)
    end
  end

  describe '#find' do
    it 'should return the Sex with the id provided' do
      expect(ReferenceData::Sex.find(4).id).to eq(4)
    end

    it 'should raise RecordNotFound id there is no Sex with the id provided' do
      expect{ ReferenceData::Sex.find(20) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the Sex with the id provided' do
      expect(ReferenceData::Sex.find_by_id(4).id).to eq(4)
    end

    it 'should return nil if there is no Sex with the id provided' do
      expect(ReferenceData::Sex.find_by_id(20)).to be_nil
    end
  end
end
