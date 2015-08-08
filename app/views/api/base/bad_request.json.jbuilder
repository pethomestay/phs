json.error 'bad-request'
json.description 'The request was malformed or invalid.'
json.message @msg unless @msg.blank?
