class ReferenceData::PetType
  attr_accessor :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def self.all
    [DOG, CAT, BIRD, FISH, OTHER]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil unless id <= all.length
    all[id - 1]
  end

  DOG = ReferenceData::PetType.new(1, 'Dog')
  CAT = ReferenceData::PetType.new(2, 'Cat')
  BIRD = ReferenceData::PetType.new(3, 'Bird')
  FISH = ReferenceData::PetType.new(4, 'Fish')
  OTHER = ReferenceData::PetType.new(5, 'Other')
end
