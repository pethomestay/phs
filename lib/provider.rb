module Provider
  def self.included(base)
    base.attr_accessible :title, :price, :location, :description
  end
end
