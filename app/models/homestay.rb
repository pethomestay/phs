require './lib/provider'

class Homestay < ActiveRecord::Base
  include Provider
end
