module Provider
  def self.included(base)
    (@klasses ||= []) << base
    base.belongs_to :user
    base.has_many :ratings, as: 'ratable'
    base.attr_accessible :title, :price, :description, \
                         :cost_per_night
    base.send :attr_accessor, :unfinished_signup
    base.validates_presence_of :cost_per_night
    base.validates_presence_of :title, :description, :unless => :unfinished_signup
  end

  def self.types
    @klasses
  end

  def self.type_strings
    @klasses.map(&:to_s).map(&:underscore)
  end

  def location
    ''
  end

  def average_rating
    if ratings.present?
      ratings.inject(0) do |sum, rating|
        sum += rating.stars
      end / ratings.count
    else
      0
    end
  end
end
