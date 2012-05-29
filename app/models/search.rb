require './app/models/sitter'
require './app/models/hotel'

class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  validates_inclusion_of :provider_type, :in => Provider.type_strings

  attr_accessor :location, :provider_type, :latitude, :longitude
  def initialize(attributes = {})
    attributes.each do |k,v|
      send "#{k}=", v if respond_to? "#{k}="
    end
  end

  def persisted?; false end

  def provider_class
    provider_type.capitalize.constantize
  end
end
