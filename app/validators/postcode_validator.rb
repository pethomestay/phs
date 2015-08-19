class PostcodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.to_s =~ /^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$/
      record.errors[attribute] << (options[:message] || 'is not a valid postcode')
    end
  end

end
