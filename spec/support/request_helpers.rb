module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def tokenised_path(path, user = nil)
      join_character = path.include?('?') ? '&' : '?'
      token_param = 'token=12345678'
      new_path = "#{path}#{join_character}#{token_param}"
      new_path += "&user_token=#{user.hex}" if user.present? && user.respond_to?(:hex)
      new_path
    end
  end
end
