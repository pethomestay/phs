class Transaction < ActiveRecord::Base

	belongs_to :booking

	def actual_amount
		self.amount.to_i.to_s + '.00'
	end

	def update_by_response(params)
		secure_pay_fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{params['refid']}|#{self.
				actual_amount}|#{params['timestamp']}|#{params['summarycode']}"
		require 'digest/sha1'
		self.secure_pay_fingerprint = Digest::SHA1.hexdigest(secure_pay_fingerprint_string)

		unless self.secure_pay_fingerprint == params['fingerprint']
			self.errors.add(:secure_pay_fingerprint, 'Transaction was not secured.')
		end

		if %w(00 08 11).include?(params['rescode']) && self.errors.blank?
			self.transaction_id = params['txnid']
			self.pre_authorisation_id = params['preauthid']
			self.response_text = params['restext']
			self.status = BOOKING_STATUS_FINISHED
			self.booking.owner_accepted = true
			self.booking.status = BOOKING_STATUS_FINISHED
			self.booking.save!
			self.save!
		else
			self.errors.add(:restext, params['restext'])
		end
	end

	def error_messages
		self.errors.messages.values.inject('') { |a,b| a = "#{a} #{b.first}" }.strip
	end

	def confirmed_by_host
		self.booking.host_accepted = true
		self.booking.save!
		self.booking
	end

	def host_view?
		self.booking.host_accepted
	end
end