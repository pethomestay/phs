class ReferenceData::Sex
  attr_accessor :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def self.all
    [MALE_DESEXED, FEMALE_DESEXED, MALE_ENTIRE, FEMALE_ENTIRE]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil unless id <= all.length
    all[id - 1]
  end

  MALE_DESEXED = ReferenceData::Sex.new(1, 'Male desexed')
  FEMALE_DESEXED = ReferenceData::Sex.new(2, 'Female desexed')
  MALE_ENTIRE = ReferenceData::Sex.new(3, 'Male entire')
  FEMALE_ENTIRE = ReferenceData::Sex.new(4, 'Female entire')
end
