class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :first_name, :last_name, :pets_attributes, :homestay_attributes, \
                  :date_of_birth, :validate_first_step_only, :mobile_number, :phone_number,
                  :address_1, :address_2, :address_suburb, :address_city, :address_country, \
                  :address_postcode, :completed_signup

  attr_accessor   :validate_first_step_only, :completed_signup
  
  has_one :homestay
  has_many :ratings
  has_many :pets
  has_many :enquiries

  validates_presence_of :first_name, :last_name, :date_of_birth, :address_1, :address_suburb, \
                        :address_city, :address_country
  validates_presence_of :completed_signup, unless: :validate_first_step_only

  accepts_nested_attributes_for :pets, reject_if: proc { |attributes|
    attributes.all? do |(key, value)|
      value.blank? || key == 'pet_type' || key == 'sex' || key == 'size' || value == '0' || key == 'pictures_attributes'
    end
  }
  accepts_nested_attributes_for :homestay, reject_if: proc { |attributes|
    attributes.all? do |(key, value)|
      value.blank? || value == "0" || key == 'address_country' || key == 'address_1' || key == 'address_2' || \
      key == 'address_suburb' || key == 'address_city' || key == 'address_postcode' || \
      key == 'is_homestay' || key == 'is_sitter' || key == 'is_services' || key == 'pictures_attributes'
    end
  }

  def name
    "#{first_name} #{last_name}"
  end

  def has_enquiries?
    homestay.present? && homestay.enquiries.present?
  end

  def enquiries
    homestay.present? ? homestay.enquiries : []
  end
end
