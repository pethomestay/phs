module Provider
  def self.included(base)
    (@klasses ||= []) << base
    base.belongs_to :user
    base.attr_accessible :title, :price, :location, :description, \
                         :cost_per_night
  end

  def self.types
    @klasses
  end

  def self.type_strings
    @klasses.map(&:to_s).map(&:underscore)
  end
end
