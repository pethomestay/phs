module Admin::BookingsHelper
  def currency_formatter(value)
    decimal = value.to_s.split('.').first
    fraction = value.to_s.split('.').last
    fraction_size = fraction.size

    if fraction_size > 2
      "$#{decimal}.#{fraction[0..1]}"
    elsif fraction_size == 1
      "$#{decimal}.#{fraction}0"
    elsif fraction_size == 2
      "$#{decimal}.#{fraction}"
    elsif fraction_size == 0
      "$#{decimal}.00"
    end
  end
end