require 'digest/sha1'
require 'rest_client'
require 'nokogiri'

class Transaction < ActiveRecord::Base

	belongs_to :booking

	belongs_to :card

	attr_accessor :store_card, :use_stored_card, :select_stored_card

	def actual_amount
		self.amount.to_i.to_s + '.00'
	end

	def update_by_response(params)
		secure_pay_fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{params['refid']}|#{self.
				actual_amount}|#{params['timestamp']}|#{params['summarycode']}"

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

		if %w(00 800).include?(params['strescode'])
			owner = self.booking.booker
			puts
			puts 'owner user becoming payor'
			puts
			puts "owner.payor?#{owner.payor?}"
			puts
			puts owner.cards.inspect
			puts
			owner.payor = true
			owner.cards.create! card_number: params['pan'], token: params['token']
			owner.save!
			puts 'owner user becomes payor'
			puts
			puts  "owner.payor?#{owner.payor?}"
			puts
			puts owner.cards.inspect
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
			if params['strestext'].to_s != params['restext'].to_s
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

	def complete_payment
		message_id = SecureRandom.hex(15)
		time_stamp = Time.now.strftime("%Y%m%dT%H%M%S%L%z")
		if self.status == TRANSACTION_HOST_CONFIRMATION_REQUIRED
			begin

				message = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><SecurePayMessage><MessageInfo><messageID>#{message_id}</messageID>
<messageTimestamp>#{time_stamp}</messageTimestamp><timeoutValue>60</timeoutValue>
<apiVersion>spxml-4.2</apiVersion></MessageInfo><MerchantInfo><merchantID>#{ENV['MERCHANT_ID']}</merchantID>
<password>#{ENV['TRANSACTION_PASSWORD']}</password></MerchantInfo><RequestType>Periodic</RequestType>
<Periodic><PeriodicList count=\"1\"><PeriodicItem ID=\"1\"><actionType>trigger</actionType>
<clientID>#{self.card.blank? ? self.booking.booker.id : self.card.token}</clientID><amount>#{self.amount * 100}</amount><currency>AUD</currency>
</PeriodicItem></PeriodicList></Periodic></SecurePayMessage>"

				puts
				puts
				puts message.inspect
				puts
				puts
				response = RestClient.post(
						ENV['TRANSACTION_XML_API'],
						message,
						content_type: 'text/xml'
				)
				puts
				puts
				puts 'stored card transaction response'
				puts
				puts response.inspect
				puts
				puts

				doc = Nokogiri::XML(response)
				if doc.xpath('//responseCode').text == "00"
					self.transaction_id = doc.xpath('//txnID').text
					self.reference = doc.xpath('//ponum').text
					self.response_text = doc.xpath('//responseText').text
					doc.xpath('//receipt').text
					doc.xpath('//currency').text
					self.status = TRANSACTION_FINISHED
					return self.save!
				else
					return doc.xpath('//responseText').text
				end
			rescue Exception => e
				return e.message
			end
		elsif self.status == TRANSACTION_PRE_AUTHORIZATION_REQUIRED

			begin
				message = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><SecurePayMessage><MessageInfo><messageID>#{message_id}</messageID>
<messageTimestamp>#{time_stamp}</messageTimestamp><timeoutValue>60</timeoutValue>
<apiVersion>spxml-4.2</apiVersion></MessageInfo><MerchantInfo><merchantID>#{ENV['MERCHANT_ID']}</merchantID>
<password>#{ENV['TRANSACTION_PASSWORD']}</password></MerchantInfo><RequestType>Payment</RequestType>
<Payment><TxnList count=\"1\"><Txn ID=\"1\"><txnType>11</txnType><txnSource>7</txnSource><amount>#{self.amount * 100}</amount>
<purchaseOrderNo>#{self.reference}</purchaseOrderNo><preauthID>#{self.pre_authorisation_id}</preauthID></Txn></TxnList></Payment>
</SecurePayMessage>"

				puts
				puts
				puts message.inspect
				puts
				puts
				response = RestClient.post(
						ENV['TRANSACTION_PRE_AUTH_COMPLETE'],
						message,
						content_type: 'text/xml'
				)
				puts
				puts
				puts 'pre auth transaction response'
				puts
				puts response.inspect
				puts
				puts

				doc = Nokogiri::XML(response)
				if doc.xpath('//responseCode').text == "00"
					self.transaction_id = doc.xpath('//txnID').text
					self.response_text = doc.xpath('//responseText').text
					doc.xpath('//receipt').text
					doc.xpath('//currency').text
					self.status = TRANSACTION_FINISHED
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

	def update_status(stored_card_id)
		self.card_id = stored_card_id
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