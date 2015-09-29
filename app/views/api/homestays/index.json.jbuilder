json.homestays do
  json.array! @search.results.each do |homestay|
    json.partial! 'homestay', homestay: homestay
  end
end
