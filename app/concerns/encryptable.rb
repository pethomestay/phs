require 'active_support/concern'

module Encryptable
  extend ActiveSupport::Concern

  def encryption_key
    # If in production. require key to be set.
    if Rails.env.production?
      raise 'Must set ENCRYPTION_KEY!' unless ENV['ENCRYPTION_KEY']
      ENV['ENCRYPTION_KEY']
    else
      ENV['ENCRYPTION_KEY'] ? ENV['ENCRYPTION_KEY'] : 'development_key'
    end
  end
end
