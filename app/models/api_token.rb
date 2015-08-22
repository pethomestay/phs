class ApiToken < ActiveRecord::Base
  validates :code, uniqueness: true
  validates :name, presence: true, uniqueness: true

  before_save :generate_code

  private

  # Generates a unique code (UUID).
  # @api private
  # @return [String] The generated code.
  # @return [nil] If a code already exists.
  def generate_code
    self.code = SecureRandom.uuid if code.blank?
  end
end
