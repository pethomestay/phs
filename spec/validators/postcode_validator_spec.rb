require 'rails_helper'

RSpec.describe PostcodeValidator do

  before(:each) do
    @validator = PostcodeValidator.new({:attributes => {}})
    @postcode = double('postcode')
    allow(@postcode).to receive(:errors).and_return([])
    allow(@postcode.errors).to receive('[]').and_return([])
  end

  it 'should validate a valid postcode' do
    expect(@postcode).to_not receive(:errors)
    @validator.validate_each(@postcode, 'postcode', '2041')
  end

  it 'should validate an invalid postcode' do
    expect(@postcode.errors[]).to receive('<<').with('is not a valid postcode')
    @validator.validate_each(@postcode, 'postcode', '0001')
  end

end
