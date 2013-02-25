class ReferenceData::Duration
  attr_accessor :id, :title, :natural

  def initialize(id, title, natural)
    @id = id
    @title = title
    @natural = natural
  end

  def self.all
    [MORNING, AFTERNOON, EVENING, OVERNIGHT, NIGHTS_2, NIGHTS_3, NIGHTS_4, NIGHTS_5, NIGHTS_6, NIGHTS_7, LONGER]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil unless id < all.length
    all[id - 1]
  end

  MORNING = ReferenceData::Duration.new(1, 'Morning', 'the morning')
  AFTERNOON = ReferenceData::Duration.new(2, 'Afternoon', 'the afternoon')
  EVENING = ReferenceData::Duration.new(3, 'Evening', 'the evening')
  OVERNIGHT = ReferenceData::Duration.new(4, 'Overnight', 'an overnight visit')
  NIGHTS_2 = ReferenceData::Duration.new(5, '2 nights', '2 nights')
  NIGHTS_3 = ReferenceData::Duration.new(6, '3 nights', '3 nights')
  NIGHTS_4 = ReferenceData::Duration.new(7, '4 nights', '4 nights')
  NIGHTS_5 = ReferenceData::Duration.new(8, '5 nights', '5 nights')
  NIGHTS_6 = ReferenceData::Duration.new(9, '6 nights', '6 nights')
  NIGHTS_7 = ReferenceData::Duration.new(10, '7 nights', '7 nights')
  LONGER = ReferenceData::Duration.new(11, 'Longer', 'Longer than 7 nights')
end
