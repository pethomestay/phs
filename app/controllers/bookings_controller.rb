class BookingsController < ApplicationController
	before_filter :authenticate_user!#, except: :transaction_result

	def new

	end

	def transaction_result
		# approved transaction
		{
				"txnid" => "196796",
        "merchant" => "EHY0047",
        "rescode" => "00",
        "expirydate" => "0715",
        "settdate" => "20131202",

        "preauthid" => "196796",

        "pan" => "444433...111",
        "timestamp" => "20131202064223",
        "fingerprint" => "6d3f1fdba34e57479c82c6fe23d9d0094a22ae59",
        "callback_status_code" => "",

        "restext" => "Approved",

        "refid" => "Test Reference",
        "summarycode" => "1",
        "controller" => "application",
        "action" => "t_results"
		}

		fingerprint = "merchant, transaction password, reference['refid'], amount, timestamp, summarycode"

		transaction = {

		}

		#transaction = Transaction.find params["refid"].split("=")[1]

		#
		#if ["00", "08", "11"].include?(params["rescode"]) && transaction.timestamp == params["timestamp"] &&
		#		transaction.fingerprint == params["fingerprint"] && params["summarycode"] == "1"
		#	transaction.t_id = params["txnid"]
		#	transaction.preauthid = params["preauthid"]
		#	transaction.restext = params["restext"]
		#else
		#	flash[:error] = "error: #{params["restext"]}"
		#	render "new"
		#end

		# invalid transaction
		{
				"merchant" => "EHY0047",
        "rescode" => "101",
        "expirydate" => "12014",
        "pan" => "321214...312",
        "timestamp" => "20131203073151",
        "fingerprint" => "4c3dce7fdc9e53e4a1aaa25f1dced110ff9c8da3",
        "callback_status_code" => "",
        "restext" => "Invalid Credit Card Number",
        "refid" => "Test Reference",
        "summarycode" => "3",
        "controller" => "application",
        "action" => "t_results"
		}
		puts
		puts
		puts
		puts params.inspect
		puts
		puts
		puts
	end
end