

describe ReferenceData::OutdoorArea, :type => :model do
  describe '#all' do
    it 'should return 3 OutdoorAreas' do
      expect(ReferenceData::OutdoorArea.all.size).to eq(3)
    end
  end

  describe '#find' do
    it 'should return the OutdoorArea with the id provided' do
      expect(ReferenceData::OutdoorArea.find(3).id).to eq(3)
    end

    it 'should raise RecordNotFound id there is no OutdoorArea with the id provided' do
      expect{ ReferenceData::OutdoorArea.find(4) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#find_by_id' do
    it 'should return the OutdoorArea with the id provided' do
      expect(ReferenceData::OutdoorArea.find_by_id(3).id).to eq(3)
    end

    it 'should return nil if there is no OutdoorArea with the id provided' do
      expect(ReferenceData::OutdoorArea.find_by_id(4)).to be_nil
    end
  end
end
