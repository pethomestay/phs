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
			self.booking.owner_accepted = true
			self.booking.status = BOOKING_STATUS_FINISHED
			enquiry = self.booking.enquiry
			unless enquiry.blank?
				enquiry.confirmed = true
				enquiry.save!
			end
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

	def booking_status
		b = self.booking
		b_status = b.status
		b_status == BOOKING_STATUS_UNFINISHED ? BOOKING_STATUS_UNFINISHED : (b.host_accepted ? 'ready to be completed' : 'awaiting host response')
	end
end