RSpec::Matchers.define :match_response_code do |code|
  match do |response|
    json = JSON.parse(response.body)
    expect(response.status).to eq(code)
    expect(response).to match_response_schema('error')
    expected_error = case code
    when 400 then 'bad-request'
    when 401 then 'unauthorised'
    when 403 then 'forbidden'
    when 404 then 'not-found'
    end
    expect(json['error']).to eq(expected_error)
  end
end
