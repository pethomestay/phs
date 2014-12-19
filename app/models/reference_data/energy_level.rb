class ReferenceData::EnergyLevel
  attr_accessor :id, :title

  def initialize(id, title)
    @id    = id
    @title = title
  end

  def self.all
    [LOW, LOW_MEDIUM, MEDIUM, HIGH_MEDIUM, HIGH]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  LOW         = ReferenceData::EnergyLevel.new(1, 'Low')
  LOW_MEDIUM  = ReferenceData::EnergyLevel.new(2, 'Low Medium')
  MEDIUM      = ReferenceData::EnergyLevel.new(3, 'Medium')
  HIGH_MEDIUM = ReferenceData::EnergyLevel.new(4, 'High Medium')
  HIGH        = ReferenceData::EnergyLevel.new(5, 'High')
end
