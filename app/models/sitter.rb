require './lib/provider'

class Sitter < ActiveRecord::Base
  include Provider
end
