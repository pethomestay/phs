require 'rails_helper'

RSpec.describe Repository::Size do

  subject { Repository::Size }

  describe ".all" do
    it {
      expected_titles = [
        "Small (0-15kg)",
        "Medium (16-30kg)",
        "Large (31-45kg)",
        "Giant (46kg+)"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end

  describe ".all_title" do
    it {
      expected_titles = [
        "Small (0-15kg)",
        "Medium (16-30kg)",
        "Large (31-45kg)",
        "Giant (46kg+)"
      ]

      expect(subject.all_titles).to match_array expected_titles
    }
  end

end
