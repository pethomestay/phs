require 'rails_helper'

RSpec.describe Repository::PropertyType do

  subject { Repository::PropertyType }

  describe ".all" do
    it {
      expected_titles = [
        "House",
        "Apartment",
        "Farm",
        "Townhouse",
        "Unit"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end
end
