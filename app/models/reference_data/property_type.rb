class ReferenceData::PropertyType
  attr_accessor :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def self.all
    [HOUSE, APARTMENT, FARM, TOWNHOUSE, UNIT]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil unless id <= all.length
    all[id - 1]
  end

  HOUSE = ReferenceData::PropertyType.new(1, 'House')
  APARTMENT = ReferenceData::PropertyType.new(2, 'Apartment')
  FARM = ReferenceData::PropertyType.new(3, 'Farm')
  TOWNHOUSE = ReferenceData::PropertyType.new(4, 'Townhouse')
  UNIT = ReferenceData::PropertyType.new(5, 'Unit')
end
