class UnavailableDate < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :date, uniqueness: true

  #TODO add this validation
  #validate :date_should_not_be_already_booked

  validate :date_should_not_be_a_past_date, if: "date.present?"

  private

  def date_should_not_be_a_past_date
    errors.add(:date, I18n.t("unavailable_date.invalid_date")) if self.date < Date.today
  end

end
