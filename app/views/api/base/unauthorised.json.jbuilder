json.error do
  json.code 401
  json.type 'unauthorised'
  json.description 'Invalid or missing API token.'
  json.messages @msg unless @msg.blank?
end
