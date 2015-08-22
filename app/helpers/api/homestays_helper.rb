module Api::HomestaysHelper

  def extract_street_address(homestay)
    homestay.address_1.titleize
  end

  def extract_suburb(homestay)
    homestay.address_suburb.titleize
  end

  def extract_state(homestay)
    nil
  end

  def extract_pet_sizes(homestay)
    homestay.pet_sizes.collect{|size| size.split.first.downcase}
  end

  def extract_energy_levels(homestay)
    homestay.energy_levels.collect{|level| level.downcase.sub(/\s+/, '-')}
  end

  def service_cost(homestay, service)
    cost = case service.to_sym
    when :local then homestay.cost_per_night
    when :remote then homestay.remote_price
    when :walking then homestay.pet_walking_price
    when :grooming then homestay.pet_grooming_price
    when :delivery then homestay.delivery_price
    end
    cost.blank? ? nil : cost.to_f
  end

  def user_avatar(user)
    user.profile_photo || user.pets.collect(&:profile_photo).compact.first
  end

end
