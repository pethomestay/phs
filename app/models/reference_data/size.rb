class ReferenceData::Size
  attr_accessor :id, :title

  def initialize(id, title)
    @id = id
    @title = title
  end

  def self.all
    [SMALL, MEDIUM, LARGE, GIANT]
  end

  def self.all_titles
    [SMALL.title, MEDIUM.title, LARGE.title, GIANT.title]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil unless id <= all.length
    all[id - 1]
  end

  SMALL = ReferenceData::Size.new(1, 'Small')
  MEDIUM = ReferenceData::Size.new(2, 'Medium')
  LARGE = ReferenceData::Size.new(3, 'Large')
  GIANT = ReferenceData::Size.new(4, 'Giant')
end
