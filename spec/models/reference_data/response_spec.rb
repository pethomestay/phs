require 'spec_helper'

describe ReferenceData::Response, :type => :model do
  describe '#all' do
    it 'should return 5 Responses' do
      expect(ReferenceData::Response.all.size).to eq(7)
    end
  end

  describe '#find' do
    it 'should return the Response with the id provided' do
      expect(ReferenceData::Response.find(4).id).to eq(4)
    end

    it 'should raise RecordNotFound id there is no Response with the id provided' do
      expect{ ReferenceData::Response.find(8) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the Response with the id provided' do
      expect(ReferenceData::Response.find_by_id(4).id).to eq(4)
    end

    it 'should return nil if there is no Response with the id provided' do
      expect(ReferenceData::Response.find_by_id(8)).to be_nil
    end
  end

	describe '#find_by_ids' do
		it 'should return the responses list with provided ids' do
			expect(ReferenceData::Response.find_by_ids([4, 5]).map(&:id)).to eq([4, 5])
		end
	end
end
