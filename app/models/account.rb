class Account < ActiveRecord::Base
  belongs_to :user

  auto_strip_attributes :account_number, :bsb, delete_whitespaces: true

  validates_presence_of :account_number, :bsb, :name
  validates_size_of :account_number, minimum: 6, maximum: 20
  validates_numericality_of :account_number, only_integer: true
  validates :bsb, length: { in: 6..12 }, numericality: { only_integer: true }

  def hidden_account_number
    ('*' * (account_number.size - 4)) + account_number.last(4)
  end
end
