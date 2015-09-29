class HomestayQuery
  include Virtus.model

  def initialize(relation = Homestay.all)
    @relation = relation.extending(Scopes)
  end

  def perform
    @relation
  end

  module Scopes
  end
end
