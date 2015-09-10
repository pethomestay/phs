class Repository::Breeds::Dog < ActiveYaml::Base
  set_filename "dog_breeds"
  field :title
end
