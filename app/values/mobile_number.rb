class MobileNumber
  VALID_LENGTHS = [10,11,13]

  attr_accessor :value

  # Initialize MobileNumber object
  #
  # @param value [String] Mobile number to base on
  # @api public
  # @return [MobileNumber]
  def initialize(value)
    @value = value
  end

  # Check legality of mobile number
  #
  # @api public
  # @return [Boolean]
  def legal?
    VALID_LENGTHS.include? normalized_value.length
  end

  # Return string value from MobileNumber object
  #
  # @api public
  # @return [String]
  def to_s
    value
  end

  private

  # Normalized Value for mobile number
  #
  # @api private
  # @return [String]
  def normalized_value
    value.to_s.gsub(/[^0-9]/, "")
  end
end
