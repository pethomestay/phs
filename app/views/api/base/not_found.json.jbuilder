json.error do
  json.code 404
  json.type 'not-found'
  json.description 'The requested resource could not be found.'
  json.messages [@msg] unless @msg.blank?
end
