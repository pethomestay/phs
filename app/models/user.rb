class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :first_name, :last_name
  has_one :homestay
  has_many :ratings
  has_many :pets
  has_many :enquiries

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
