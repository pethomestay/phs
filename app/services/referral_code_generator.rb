class ReferralCodeGenerator
  attr_reader :model
  attr_accessor :args

  # Initialize Generator
  #
  # @api public
  # @param model [Object] Object that responds to first_name and last_name
  #        args  [Hash] accepts :custom_discount, :custom_credit, :custom_code
  # @return [ReferralCodeGenerator]
  def initialize(model, args)
    @model = model
    @args = args
  end

  # Generate postcode
  #
  # @api public
  # @return [Hash]
  def generate
    {
      code: final_code,
      discount_amount: discount_amount,
      credit_referrer_amount: referrer_amount,
      valid_from: Date.today
    }
  end

  private

  # Discount amount
  #
  # @api private
  # @return [Fixnum]
  def discount_amount
    args[:custom_discount] || Coupon::DEFAULT_DISCOUNT_AMOUNT
  end

  # Referrer amount
  #
  # @api private
  # @return [Fixnum]
  def referrer_amount
    args[:custom_credit] || Coupon::DEFAULT_CREDIT_REFERRER_AMOUNT
  end

  # Final code
  #
  # @api private
  # @return [String]
  def final_code
    return args[:custom_code].upcase if args[:custom_code].present?

    "#{duplicate_count}#{suggested_code}#{Coupon::DEFAULT_DISCOUNT_AMOUNT}".upcase
  end

  # Suggested code
  #
  # @api private
  # @return [String]
  def suggested_code
    value  = model.first_name.gsub(/[^a-z]/i, '')[0..3]
    value += model.last_name.gsub(/[^a-z]/i, '')[0]
    value += "XXXXX"

    value[0..4].upcase
  end

  # Duplicate coupon count
  #
  # @api private
  # @return [Integer]
  def duplicate_count
    non_unique = Coupon.where("code LIKE ?", "%#{suggested_code}%").count

    non_unique if non_unique > 0
  end
end
