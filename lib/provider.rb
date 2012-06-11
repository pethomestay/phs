module Provider
  def self.included(base)
    (@klasses ||= []) << base
    base.belongs_to :user
    base.has_many :ratings, as: 'ratable'
    base.attr_accessible :title, :price, :location, :description, \
                         :cost_per_night
  end

  def self.types
    @klasses
  end

  def self.type_strings
    @klasses.map(&:to_s).map(&:underscore)
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
