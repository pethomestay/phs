

describe ReferenceData::PetType, :type => :model do
  describe '#all' do
    it 'should return 5 PetTypes' do
      expect(ReferenceData::PetType.all.size).to eq(5)
    end
  end

  describe '#find' do
    it 'should return the PetType with the id provided' do
      expect(ReferenceData::PetType.find(5).id).to eq(5)
    end

    it 'should raise RecordNotFound id there is no PetType with the id provided' do
      expect{ ReferenceData::PetType.find(20) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the PetType with the id provided' do
      expect(ReferenceData::PetType.find_by_id(5).id).to eq(5)
    end

    it 'should return nil if there is no PetType with the id provided' do
      expect(ReferenceData::PetType.find_by_id(20)).to be_nil
    end
  end
end
