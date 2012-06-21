require './app/models/sitter'
require './app/models/hotel'

class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  validates_presence_of :provider_types

  attr_accessor :location, :provider_types, :latitude, :longitude, :within, :sort_by
  def initialize(attributes = {})
    attributes.each do |k,v|
      send "#{k}=", v if respond_to? "#{k}="
    end
  end

  def persisted?; false end

  def hotel?
    provider_types['hotel'] == '1'
  end

  def sitter?
    provider_types['sitter'] == '1'
  end

  def provider_classes
    provider_types.keep_if do |k,v|
      v == '1'
    end.keys.map(&:capitalize).map(&:constantize)
  end

  def sort_by
    @sort_by ||= 'distance'
  end
end
