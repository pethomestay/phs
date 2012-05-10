require './lib/provider'

class Hotel < ActiveRecord::Base
  include Provider
end
