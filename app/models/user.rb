class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :first_name, :last_name, :pets_attributes, :homestay_attributes, \
                  :date_of_birth
  
  has_one :homestay
  has_many :ratings
  has_many :pets
  has_many :enquiries

  validates_presence_of :first_name, :last_name, :date_of_birth

  accepts_nested_attributes_for :pets, reject_if: proc { |attributes|
    attributes.all? do |(key, value)|
      value.blank? || key == 'type' || key == 'sex' || key == 'size' || value == '0'
    end
  }
  accepts_nested_attributes_for :homestay, reject_if: proc { |attributes|
    attributes.all? do |(key, value)|
      value.blank? || key == 'address_country'
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
