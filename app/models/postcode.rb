class Postcode < ActiveRecord::Base

  COUNTRY = 'Australia'

  validates :postcode, postcode: true, presence: true, uniqueness: true

  geocoded_by :address

  before_save :geocode

  # Looks for an existing matching postcode. If none exists, it creates one.
  # @api public
  # @param postcode [String] The postcode to lookup.
  # @raise [ArgumentError] If the passed postcode is invalid.
  # @return [Postcode] The matching postcode.
  def self.lookup(code)
    code = '%04d' % code.to_i
    postcode = Postcode.where(postcode: code).first
    if postcode.blank?
      postcode = Postcode.new(postcode: code)
      if postcode.valid?
        postcode.save
      else
        raise ArgumentError, 'Invalid postcode.'
      end
    end
    postcode
  end

  # Provides a Geocoder-friendly address.
  # @api public
  # @return [String] The address.
  def address
    "#{postcode}, #{COUNTRY}"
  end

end
