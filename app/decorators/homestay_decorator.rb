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
      "I know pet first-aid and can provide emergency transport"
    elsif first_aid?
      "I know pet first-aid"
    elsif emergency_transport?
      "I can provide emergency transport"
    end
  end

  # Depreciated but may be used in other parts of the program, especially emails
  def pretty_supervision
    if constant_supervision?
      "I can provide 24/7 supervision for your pets"
    elsif supervision_outside_work_hours?
      "I can provide supervision for your pets outside work hours (8am - 6pm)"
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

  private

    def auto_interest_sms_template
      "Hi, I would love to help look after your pet. Let's arrange a time to meet. My contact is #{user_contact}"
    end

    def auto_decline_sms_template
      "Sorry - I can't help this time, but please ask again in the future!"
    end

end
