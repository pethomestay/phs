json.error do
  json.code 401
  json.type 'unauthorised'
  json.description 'Invalid or missing API token.'
  unless @msg.blank?
    json.messages @msg.kind_of?(Array) ? @msg : [@msg]
  end
end
