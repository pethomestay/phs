require 'spec_helper'

describe Contact do
  it 'shoud be able to be initialized with a name' do
    Contact.new(name: 'a name').name.should == 'a name'
  end

  it 'shoud be able to be initialized with an email' do
    Contact.new(email: 'test@test.net').email.should == 'test@test.net'
  end

  it 'shoud be able to be initialized with a message' do
    Contact.new(message: 'hi there').message.should == 'hi there'
  end

  it 'should not be persisted' do
    Contact.new.should_not be_persisted
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :message }
end
