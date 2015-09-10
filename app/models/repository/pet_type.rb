class Repository::PetType < ActiveYaml::Base
  set_filename "pet_types"
  field :title

  def self.dog_cat_other
    @dog_cat_other ||= [
      find_by_title("Dog"),
      find_by_title("Cat"),
      find_by_title("Other")
    ]
  end
end
