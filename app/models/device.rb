class Device < ActiveRecord::Base
  belongs_to :user

  validates :token, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
end