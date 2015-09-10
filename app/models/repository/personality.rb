class Repository::Personality < ActiveYaml::Base
  set_filename "personalities"
  field :title
end
