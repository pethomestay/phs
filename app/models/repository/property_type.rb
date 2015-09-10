class Repository::PropertyType < ActiveYaml::Base
  set_filename "property_types"
  field :title
end
