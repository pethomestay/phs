class UserDecorator < SimpleDelegator

  # Return pet name
  #
  # @api public
  # @return [String]
  def pet_name
    if pets.length == 1
      pets.first.name
    else
      "your pets"
    end
  end

  # Return pet names on a sentence
  #
  # @api public
  # @return [String]
  def pet_names
    pets.map(&:name).to_sentence
  end

  # Return pet breed on a sentence
  #
  # @api public
  # @return [String]
  def pet_breed
    pets.map(&:breed).to_sentence
  end

  # Return first pet
  #
  # @api public
  # @return [Pet]
  def pet
    pets.first
  end

  # Return complete address
  #
  # @api public
  # @return [String]
  def complete_address
    "#{self.address_1} #{self.address_suburb}, #{self.address_city}, #{self.address_country}."
  end

end
