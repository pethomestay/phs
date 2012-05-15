class Search
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  validates_inclusion_of :provider_type, :in => %w( hotel sitter )

  attr_accessor :location, :provider_type
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
