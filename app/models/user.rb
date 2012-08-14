class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :first_name, :last_name, :pets_attributes, :homestay_attributes, \
                  :date_of_birth, :validate_first_step_only, :mobile_number, :phone_number,
                  :address_1, :address_2, :address_suburb, :address_city, :address_country, \
                  :address_postcode, :completed_signup, :current_password

  attr_accessor   :validate_first_step_only, :completed_signup, :current_password
  
  has_one :homestay
  has_many :ratings
  has_many :pets
  has_many :enquiries

  validates_presence_of :first_name, :last_name, :date_of_birth, :address_1, :address_suburb, \
                        :address_city, :address_country
  validates_presence_of :completed_signup, unless: :validate_first_step_only, on: :create

  accepts_nested_attributes_for :pets, reject_if: proc { |attributes|
    attributes.all? do |(key, value)|
      value.blank? || key == 'pet_type' || key == 'sex' || key == 'breed' || key == 'size' || value == '0' || key == 'pictures_attributes'
    end
  }
  accepts_nested_attributes_for :homestay, reject_if: proc { |attributes|
    attributes.all? do |(key, value)|
      value.blank? || value == "0" || key == 'address_country' || key == 'address_1' || key == 'address_2' || \
      key == 'address_suburb' || key == 'address_city' || key == 'address_postcode' || \
      key == 'property_type' || key == 'outdoor_area' || \
      key == 'is_homestay' || key == 'is_sitter' || key == 'is_services' || key == 'pictures_attributes'
    end
  }

  def name
    "#{first_name} #{last_name}"
  end

  def pet_names
    pets.map(&:name).to_sentence
  end

  def has_unanswered_enquiries?
    unanswered_enquiries.present?
  end

  def unanswered_enquiries
    Enquiry.unanswered(self)
  end

  def homestay_id
    homestay.present? ? homestay.id : nil
  end

  def pets_by_type
    pets.inject({}) do |hash, pet|
      hash[pet.pet_type] ||= []
      hash[pet.pet_type] << pet
      hash
    end
  end

  def pet_name
    if pets.length == 1
      pets.first.name
    else
      "your pets"
    end
  end

  def pet_count_by_type
    pets_by_type.inject({}) do |hash, (k,v)|
      hash[k] = v.length
      hash
    end
  end

  def pet_count_summary
    pet_count_by_type.map do |k,v|
      "#{v} #{k.pluralize(v)}"
    end.join(', ')
  end

  def pet_summary
    "#{pets.length} #{'pet'.pluralize(pets.length)} (#{pet_count_summary})"
  end
end
