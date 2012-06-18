require './lib/provider'
require 'will_paginate/array'

class Sitter < ActiveRecord::Base
  extend Forwardable
  include Provider
  has_many :pictures, as: 'picturable'
  accepts_nested_attributes_for :pictures

  attr_accessible :distance
  def_delegators  :user, :address_1, :address_2, :address_suburb, \
                  :address_city, :address_postcode, :latitude, :longitude

  def self.near(*args)
    users = User.near(*args)
    ids = users.map(&:id)
    sitters = self.where(user_id: ids)
    sitters.select do |sitter|
      sitter.distance >= users.find(sitter.user_id).distance.to_f
    end
  end

  def self.default_within
    100
  end

  def location
    "#{address_suburb}, #{address_city}"
  end
end
