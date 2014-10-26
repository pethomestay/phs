

describe Contact, :type => :model do
  it 'shoud be able to be initialized with a name' do
    expect(Contact.new(name: 'a name').name).to eq('a name')
  end

  it 'shoud be able to be initialized with an email' do
    expect(Contact.new(email: 'test@test.net').email).to eq('test@test.net')
  end

  it 'shoud be able to be initialized with a message' do
    expect(Contact.new(message: 'hi there').message).to eq('hi there')
  end

  it 'should not be persisted' do
    expect(Contact.new).not_to be_persisted
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :message }
end
