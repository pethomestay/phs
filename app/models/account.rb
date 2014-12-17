class Account < ActiveRecord::Base
  include Encryptable

  belongs_to :user

  auto_strip_attributes :account_number, :bsb, delete_whitespaces: true

  validates_presence_of :account_number, :bsb, :name
  validates_size_of :account_number, minimum: 6, maximum: 20
  validates_numericality_of :account_number, only_integer: true
  validates :bsb, length: { in: 6..12 }, numericality: { only_integer: true }

  attr_encrypted_options.merge! key: :encryption_key,
                                unless: Rails.env.development?
  attr_encryptor :bsb
  attr_encryptor :name
  attr_encryptor :account_number

  def hidden_account_number
    ('*' * (account_number.size - 4)) + account_number.last(4)
  end
end
