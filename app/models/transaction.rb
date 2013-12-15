class Transaction < ActiveRecord::Base
	belongs_to :user
	belongs_to :enquiry

	def actual_amount
		self.amount.to_i.to_s + '.00'
	end

	def update_by_response params
		secure_pay_fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{params['refid']}|#{self.actual_amount}|#{params['timestamp']}|#{params['summarycode']}"

		require 'digest/sha1'
		self.secure_pay_fingerprint = Digest::SHA1.hexdigest(secure_pay_fingerprint_string)

		unless self.secure_pay_fingerprint == params['fingerprint']
			self.errors.add(:secure_pay_fingerprint, 'Transaction was not secured.')
		end

		if ['00', '08', '11'].include?(params['rescode']) && self.errors.blank?
			self.t_id = params['txnid']
			self.preauthid = params['preauthid']
			self.restext = params['restext']
			self.status = TRANSACTION_STATUS_APPROVED
			self.enquiry.owner_accepted = true
			self.enquiry.confirmed = true
			self.enquiry.save!
			self.save!
		else
			self.errors.add(:restext, params['restext'])
		end
	end

	def error_messages
		self.errors.messages.values.inject('') { |a,b| a = "#{a} #{b.first}" }.strip
	end

	def confirmed_by_host
		self.enquiry.host_accepted = true
		self.enquiry.save!
		{
				check_in_date: self.enquiry.check_in_date.blank? ? Time.now : self.enquiry.check_in_date,
				check_out_date: self.enquiry.check_out_date.blank? ? Time.now : self.enquiry.check_in_date,
				no_of_nights: 1,
				rate_per_night: self.enquiry.homestay.cost_per_night,
				amount: self.amount.to_i
		}
	end

	def host_view?
		self.enquiry.host_accepted
	end
end