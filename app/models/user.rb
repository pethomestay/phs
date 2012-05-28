class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :wants_to_be_sitter, :wants_to_be_hotel
  has_one :hotel
  has_one :sitter

  def wants_to_be_hotel?
    super || wants_to_be_professional_hotel?
  end
end
