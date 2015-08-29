json.error do
  json.code 403
  json.type 'forbidden'
  json.description 'You do not have permission to perform the request.'
  unless @msg.blank?
    json.messages @msg.kind_of?(Array) ? @msg : [@msg]
  end
end
