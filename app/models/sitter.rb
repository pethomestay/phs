require './lib/provider'

class Sitter < ActiveRecord::Base
  extend Forwardable
  include Provider

  def_delegators  :user, :address_1, :address_2, :address_suburb, \
                  :address_city, :address_postcode, :latitude, :longitude

  def self.near(*args)
    ids = User.near(*args).map(&:id)
    self.where(user_id: ids)
  end
end
