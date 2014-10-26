

describe ReferenceData::PropertyType, :type => :model do
  describe '#all' do
    it 'should return 5 PropertyTypes' do
      expect(ReferenceData::PropertyType.all.size).to eq(5)
    end
  end

  describe '#find' do
    it 'should return the PropertyType with the id provided' do
      expect(ReferenceData::PropertyType.find(5).id).to eq(5)
    end

    it 'should raise RecordNotFound id there is no PropertyType with the id provided' do
      expect{ ReferenceData::PropertyType.find(20) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the PropertyType with the id provided' do
      expect(ReferenceData::PropertyType.find_by_id(5).id).to eq(5)
    end

    it 'should return nil if there is no PropertyType with the id provided' do
      expect(ReferenceData::PropertyType.find_by_id(20)).to be_nil
    end
  end
end
