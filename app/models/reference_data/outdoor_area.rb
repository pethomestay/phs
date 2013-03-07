class ReferenceData::OutdoorArea
  attr_accessor :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def self.all
    [SMALL, MEDIUM, LARGE]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil unless id <= all.length
    all[id - 1]
  end

  SMALL = ReferenceData::OutdoorArea.new(1, 'Small')
  MEDIUM = ReferenceData::OutdoorArea.new(2, 'Medium')
  LARGE = ReferenceData::OutdoorArea.new(3, 'Large')
end
