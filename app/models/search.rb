class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  attr_accessor :location, :provider_types, :latitude, :longitude, :within, :sort_by, \
                :is_sitter, :is_homestay, :is_services
  def initialize(attributes = {})
    attributes.each do |k,v|
      send "#{k}=", v if respond_to? "#{k}="
    end
  end

  def persisted?; false end

  def is_homestay
    @is_homestay ||= true
  end

  def is_sitter
    @is_sitter ||= true
  end

  def is_services
    @is_services ||= false
  end

  def sitter?
    provider_types['sitter'] == '1'
  end

  def sort_by
    @sort_by ||= 'distance'
  end

  def within
    @within || 20
  end
end
