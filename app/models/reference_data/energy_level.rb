class ReferenceData::EnergyLevel
  attr_reader :id, :title

  @@all = []

  def initialize(opts={})
    @id    = opts[:id]
    @title = opts[:title]
    @@all << self
  end

  def self.all
    @@all
  end

  def self.find(id)
    @@all.each do |energy_level|
      # FIXME:
      # This should be returning the energy_level object, not the title attribute.
      return energy_level.title if energy_level.id == id
    end
    raise ActiveRecord::RecordNotFound.new
  end
end

LOW         = ReferenceData::EnergyLevel.new id: '1', title: 'Low'
LOW_MEDIUM  = ReferenceData::EnergyLevel.new id: '2', title: 'Low Medium'
MEDIUM      = ReferenceData::EnergyLevel.new id: '3', title: 'Medium'
HIGH_MEDIUM = ReferenceData::EnergyLevel.new id: '4', title: 'High Medium'
HIGH        = ReferenceData::EnergyLevel.new id: '5', title: 'High'
