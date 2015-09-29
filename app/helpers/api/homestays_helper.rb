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

  def extract_pet_size_ids(homestay)
    homestay.pet_sizes.collect{|size| ReferenceData::Size.all_titles.index(size) + 1}
  end

  def extract_energy_level_ids(homestay)
    homestay.energy_level_ids.collect(&:to_i)
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
