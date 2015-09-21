class HomestayDecorator < SimpleDelegator

  def geocoding_address
    if address_suburb.nil? && address_1.nil?
      "#{address_city}, #{address_country}"
    elsif address_suburb.nil?
      "#{address_1}, #{address_city}, #{address_country}"
    elsif address_1.nil?
      "#{address_suburb}, #{address_city}, #{address_country}"
    elsif address_suburb.present? && address_1.present?
      "#{address_1}, #{address_suburb}, #{address_city}, #{address_country}"
    end
  end

  def auto_decline_sms_text
    auto_decline_sms.present? ? auto_decline_sms : auto_decline_sms_template
  end

  def auto_interest_sms_text
    auto_interest_sms.present? ? auto_interest_sms : auto_interest_sms_template
  end

  def pretty_emergency_preparedness
    if first_aid? && emergency_transport?
      I18n.t('decorator.homestay.emergency_preparedness.both')
    elsif first_aid?
      I18n.t('decorator.homestay.emergency_preparedness.first_aid_only')
    elsif emergency_transport?
      I18n.t('decorator.homestay.emergency_preparedness.transport_only')
    end
  end

  # Depreciated but may be used in other parts of the program, especially emails
  def pretty_supervision
    if constant_supervision?
      I18n.t('decorator.homestay.supervision.constant')
    elsif supervision_outside_work_hours?
      I18n.t('decorator.homestay.supervision.outside_work_hours')
    end
  end

  def location
    if address_suburb != address_city
      "#{address_suburb}, #{address_city}" # "Avoid Melbourne, Melbourne"
    else
      "#{address_suburb}"
    end
  end

  def user_contact
    user.mobile_number.present? ? user.mobile_number : user.email
  end

  def pretty_services
    services = []
    services << I18n.t('decorator.homestay.services.pet_feeding') if pet_feeding?
    services << I18n.t('decorator.homestay.services.pet_grooming') if pet_grooming?
    services << I18n.t('decorator.homestay.services.pet_training') if pet_training?
    services << I18n.t('decorator.homestay.services.pet_walking')  if pet_walking?
    services.to_sentence.downcase.capitalize
  end

  private

    def auto_interest_sms_template
      I18n.t('decorator.homestay.auto_interest_sms', user_contact: user_contact)
    end

    def auto_decline_sms_template
      I18n.t('decorator.homestay.auto_decline_sms')
    end

end
