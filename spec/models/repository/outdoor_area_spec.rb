require 'rails_helper'

RSpec.describe Repository::OutdoorArea do

  subject { Repository::OutdoorArea }

  describe ".all" do
    it {
      expected_titles = [
        "Small",
        "Medium",
        "Large"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end

end
