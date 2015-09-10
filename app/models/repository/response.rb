class Repository::Response < ActiveYaml::Base
  set_filename "responses"
  field :title
  field :description

  def self.find_by_ids(ids)
    ids.inject([]) { |arr, id| arr << find(id) if id <= all.size }
  end
end
