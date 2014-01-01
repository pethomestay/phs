class Transaction < ActiveRecord::Base

	belongs_to :booking

	attr_accessor :store_card, :use_stored_card

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
		puts
		puts 'pre-auth transaction response from securepay'
		puts
		puts params.inspect
		puts
		puts
		# TODO: '346' will only work for Heroku staging and development environment
		if ['800', '346'].include?(params['strescode'])
			owner = self.booking.booker
			puts 'owner user becoming payor'
			puts owner.inspect
			puts
			puts
			owner.payor = true
			owner.save!
			puts 'owner user becomes payor'
			puts owner.inspect
			puts
			puts
		end

		if %w(00 08 11).include?(params['rescode']) && self.errors.blank?
			self.transaction_id = params['txnid']
			self.pre_authorisation_id = params['preauthid']
			self.response_text = params['restext']
			self.status = TRANSACTION_PRE_AUTHORIZATION_REQUIRED
			self.finish_booking
			self.save!
		else
			self.errors.add(:response_text, params['restext'])
			if params['strestext'] != params['restext']
				self.errors.add(:storage_text, params['strestext'])
			end
		end
	end

	def finish_booking
		self.booking.owner_accepted = true
		self.booking.status = BOOKING_STATUS_FINISHED
		enquiry = self.booking.enquiry
		unless enquiry.blank?
			enquiry.confirmed = true
			enquiry.save!
		end
		self.booking.save!
	end

	def payor_type?
		self.status == TRANSACTION_HOST_CONFIRMATION_REQUIRED
	end

	def complete_payment

		if self.payor_type?
			begin
				require 'rest_client'
				message_id = SecureRandom.hex(15)
				time_stamp = Time.now.strftime("%Y%m%dT%H%M%S%L%z")
				response = RestClient.post(
						ENV['TRANSACTION_XML_API'],
						"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SecurePayMessage><MessageInfo><messageID>#{message_id}</messageID>
						<messageTimestamp>#{time_stamp}</messageTimestamp><timeoutValue>60</timeoutValue>
						<apiVersion>spxml-4.2</apiVersion></MessageInfo><MerchantInfo><merchantID>#{ENV['MERCHANT_ID']}</merchantID>
						<password>#{ENV['TRANSACTION_PASSWORD']}</password></MerchantInfo><RequestType>Periodic</RequestType>
						<Periodic><PeriodicList count=\"1\"><PeriodicItem ID=\"1\"><actionType>trigger</actionType>
						<clientID>#{self.booking.booker.id}</clientID><amount>#{self.amount * 100}</amount><currency>AUD</currency>
						</PeriodicItem></PeriodicList></Periodic></SecurePayMessage>",
						content_type: 'text/xml'
				)
				puts
				puts
				puts 'stored card transaction response'
				puts
				puts response.inspect
				puts
				puts
				require 'nokogiri'
				doc = Nokogiri::XML(response)
				if doc.xpath('//responseCode').text == "00"
					self.transaction_id = doc.xpath('//txnID').text
					self.reference = doc.xpath('//receipt').text
					self.response_text = doc.xpath('//responseText').text
					doc.xpath('//ponum').text
					doc.xpath('//currency').text
					return self.save!
				else
					return doc.xpath('//responseText').text
				end
			rescue Exception => e
				return e.message
			end
		end
		false
	end

	def update_status
		self.finish_booking
		self.status = TRANSACTION_HOST_CONFIRMATION_REQUIRED
		self.save!
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