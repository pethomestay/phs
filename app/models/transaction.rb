class Transaction < ActiveRecord::Base
	belongs_to :user

	def actual_amount
		self.amount.to_i.to_s + ".00"
	end

	def update_by_response params
		secure_pay_fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{params["refid"]}|#{self.actual_amount}|#{params["timestamp"]}|#{params["summarycode"]}"

		require 'digest/sha1'
		self.secure_pay_fingerprint = Digest::SHA1.hexdigest(secure_pay_fingerprint_string)

		unless self.secure_pay_fingerprint == params["fingerprint"]
			self.errors.add(:secure_pay_fingerprint, "Transaction was not secured.")
		end

		if ["00", "08", "11"].include?(params["rescode"])
			self.t_id = params["txnid"]
			self.preauthid = params["preauthid"]
			self.restext = params["restext"]
			self.status = TRANSACTION_STATUS_APPROVED
			self.save(validate: false)
		else
			self.errors.add(:restext, params["restext"])
		end
	end

	def error_messages
		self.errors.messages.values.inject("") { |a,b| a = "#{a} #{b.first}" }.strip
	end
end