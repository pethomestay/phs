class ReferenceData::Personality
  attr_accessor :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def self.all
    [HAPPY, SAD]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil unless id <= all.length
    all[id - 1]
  end

  HAPPY = ReferenceData::Personality.new(1, 'Happy')
  SAD   = ReferenceData::Personality.new(2, 'Sad')
end
