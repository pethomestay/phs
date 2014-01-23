class Account < ActiveRecord::Base
	belongs_to :user

	validates_presence_of :account_number, :bank, :bsb, :name
	validates_size_of :account_number, minimum: 7, maximum: 20
	validates_numericality_of :account_number, only_integer: true

	def hidden_account_number
		('*' * (account_number.size - 4)) + account_number.last(4)
	end
end