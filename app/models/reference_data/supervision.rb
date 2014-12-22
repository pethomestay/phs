class ReferenceData::Supervision
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
    @@all.each do |supervision|
      return supervision.title if supervision.id == id
    end
    raise ActiveRecord::RecordNotFound.new
  end
end

ANYTIME       = ReferenceData::Supervision.new id: 1, title: '24x7 Care'
EVENINGS      = ReferenceData::Supervision.new id: 2, title: 'Evenings'
WEEKENDS_ONLY = ReferenceData::Supervision.new id: 3, title: 'Weekends Only'
