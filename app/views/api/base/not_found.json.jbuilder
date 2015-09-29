json.error do
  json.code 404
  json.type 'not-found'
  json.description 'The requested resource could not be found.'
  unless @msg.blank?
    json.messages @msg.kind_of?(Array) ? @msg : [@msg]
  end
end
