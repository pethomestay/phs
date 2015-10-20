class Visitor

  attr_accessor :id

  def self.find_or_initialize_by_id(id)
    new.tap do |obj|
      obj.id = id.present? ? id : SecureRandom.hex(25)
    end
  end

end
