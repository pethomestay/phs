class Repository::Size < ActiveYaml::Base
  set_filename "sizes"
  field :title

  def self.all_titles
    @all_titles ||= all.map(&:title)
  end

end
