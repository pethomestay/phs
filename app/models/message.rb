class Message < ActiveRecord::Base
	belongs_to :mailbox
	belongs_to :user
end