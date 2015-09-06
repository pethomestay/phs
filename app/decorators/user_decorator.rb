class UserDecorator < SimpleDelegator

  def pet_name
    if pets.length == 1
      pets.first.name
    else
      "your pets"
    end
  end

  def pet_names
    pets.map(&:name).to_sentence
  end

  def pet_breed
    pets.map(&:breed).to_sentence
  end

  def pet
    pets.first
  end

end
