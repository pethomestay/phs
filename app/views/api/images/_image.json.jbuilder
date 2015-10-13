if image.blank?
  json.null!
else
  json.type image.attachinariable_type.downcase.gsub(/\s+/, '-')
  json.id image.public_id
end
