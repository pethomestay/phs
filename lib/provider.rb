module Provider
  def self.included(base)
    base.belongs_to :user
    base.attr_accessible :title, :price, :location, :description
  end
end
