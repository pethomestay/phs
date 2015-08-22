json.error do
  json.code 400
  json.type 'bad-request'
  json.description 'The request was malformed or invalid.'
  json.messages [@msg] unless @msg.blank?
end
