require 'digest/sha1'
require 'rest_client'
require 'nokogiri'

class Transaction < ActiveRecord::Base

	belongs_to :booking

	belongs_to :card

	attr_accessor :store_card, :use_stored_card, :select_stored_card, :eps_redirect, :eps_merchant

	def actual_amount
		booking.actual_amount
	end

	def update_by_response(secure_pay_response)
		secure_pay_fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{secure_pay_response[:reference_id]}|#{self.
				actual_amount}|#{secure_pay_response[:time_stamp]}|#{secure_pay_response[:summary_code]}"
		self.secure_pay_fingerprint = Digest::SHA1.hexdigest(secure_pay_fingerprint_string)

		unless self.secure_pay_fingerprint == secure_pay_response[:fingerprint]
			self.errors.add(:secure_pay_fingerprint, 'Transaction was not secured.')
		end

		if %w(00 800).include?(secure_pay_response[:card_storage_response_code]) && self.errors.blank?
			owner = self.booking.booker
			owner.payor = true
			owner.cards.create!(card_number: secure_pay_response[:card_number], token: secure_pay_response[:token])
			owner.save!
		end

		if %w(00 08 11).include?(secure_pay_response[:response_code]) && self.errors.blank?
			self.transaction_id = secure_pay_response[:transaction_id]
			self.pre_authorisation_id = secure_pay_response[:pre_authorization_id]
			self.response_text = secure_pay_response[:response_text]
			self.status = TRANSACTION_PRE_AUTHORIZATION_REQUIRED
			self.finish_booking
			self.save!
		else
			self.errors.add(:response_text, secure_pay_response[:response_text])
			if secure_pay_response[:card_storage_response_text].to_s != secure_pay_response[:response_text].to_s
				self.errors.add(:storage_text, secure_pay_response[:card_storage_response_text])
			end
		end
		self
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
		self.booking.reload
	end

	def complete_payment
		message_id = SecureRandom.hex(15)
		time_stamp = Time.now.strftime('%Y%m%dT%H%M%S%L%z')
		if self.status == TRANSACTION_HOST_CONFIRMATION_REQUIRED
			begin
				message = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><SecurePayMessage><MessageInfo><messageID>#{message_id}</messageID>
<messageTimestamp>#{time_stamp}</messageTimestamp><timeoutValue>60</timeoutValue>
<apiVersion>spxml-4.2</apiVersion></MessageInfo><MerchantInfo><merchantID>#{ENV['MERCHANT_ID']}</merchantID>
<password>#{ENV['TRANSACTION_PASSWORD']}</password></MerchantInfo><RequestType>Periodic</RequestType>
<Periodic><PeriodicList count=\"1\"><PeriodicItem ID=\"1\"><actionType>trigger</actionType>
<clientID>#{self.card.blank? ? self.booking.booker.id : self.card.token}</clientID><amount>#{(self.amount * 100).to_i}</amount><currency>AUD</currency>
</PeriodicItem></PeriodicList></Periodic></SecurePayMessage>"

				response = RestClient.post(
						ENV['TRANSACTION_XML_API'],
						message,
						content_type: 'text/xml'
				)

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
<Payment><TxnList count=\"1\"><Txn ID=\"1\"><txnType>11</txnType><txnSource>7</txnSource><amount>#{(self.amount * 100).to_i}</amount>
<purchaseOrderNo>#{self.reference}</purchaseOrderNo><preauthID>#{self.pre_authorisation_id}</preauthID></Txn></TxnList></Payment>
</SecurePayMessage>"

				response = RestClient.post(
						ENV['TRANSACTION_PRE_AUTH_COMPLETE'],
						message,
						content_type: 'text/xml'
				)

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

	def update_status(stored_card_id=nil)
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