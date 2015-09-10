require 'rails_helper'

RSpec.describe Repository::Supervision do

  subject { Repository::Supervision }

  describe ".all" do
    it {
      expected_titles = [
        "24x7 Care",
        "Evenings",
        "Weekends Only"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end
end
