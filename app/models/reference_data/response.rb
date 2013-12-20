class ReferenceData::Response
  attr_accessor :id, :title, :description

  def initialize(id, title, description)
    @id = id
    @title = title
    @description = description
  end

  def self.all
    [NONE, ACCEPTED, UNDECIDED, DECLINED, AVAILABLE, UNAVAILABLE, QUESTION]
  end

  def self.find(id)
    raise ActiveRecord::RecordNotFound.new unless id <=  all.length
    all[id - 1]
  end

  def self.find_by_id(id)
    return nil if id > all.size
    all[id - 1]
  end

  def self.find_by_ids(ids)
	  ids.inject([]) { |arr, id| arr << find(id) if id <= all.size }
  end

  NONE = ReferenceData::Response.new(1, 'None', 'No Response')
  ACCEPTED = ReferenceData::Response.new(2, 'Accepted', 'I can do it')
  UNDECIDED = ReferenceData::Response.new(3, 'Undecided', 'I might be able to do it')
  DECLINED = ReferenceData::Response.new(4, 'Declined', "I can't do it")

  AVAILABLE = ReferenceData::Response.new(5, 'Available', 'Available')
  UNAVAILABLE = ReferenceData::Response.new(6, 'Unavailable', 'Not available')
  QUESTION = ReferenceData::Response.new(7, 'Question', 'Have questions')
end
