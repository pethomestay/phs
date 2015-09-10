require 'rails_helper'

RSpec.describe Repository::PetType do

  subject { Repository::PetType }

  describe ".all" do
    it {
      expected_titles = [
        "Dog",
        "Cat",
        "Bird",
        "Fish",
        "Other"
      ]

      expect(subject.all.map(&:title)).to match_array expected_titles
    }
  end

  describe ".dog_cat_other" do
    it {
      expected_titles = [
        "Dog",
        "Cat",
        "Other"
      ]

      expect(subject.dog_cat_other.map(&:title)).to match_array expected_titles
    }
  end

end
