require 'rails_helper'

RSpec.describe Repository::EnergyLevel do

  subject { Repository::EnergyLevel }

  describe ".all" do
    it {
      expected_titles = [
        "Low",
        "Low Medium",
        "Medium",
        "High Medium",
        "High"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end

end
