json.error do
  json.code 400
  json.type 'bad-request'
  json.description 'The request was malformed or invalid.'
  unless @msg.blank?
    json.messages @msg.kind_of?(Array) ? @msg : [@msg]
  end
end
