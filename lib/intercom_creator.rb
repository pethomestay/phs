class IntercomCreator
  def self.create_event(options = {})
    begin
      Intercom::Event.create(options)
    rescue Intercom::MultipleMatchingUsersError, Intercom::ResourceNotFound
    end
  end

  def self.create_message(options = {})
    begin
      Intercom::Message.create(options)
    rescue Intercom::MultipleMatchingUsersError, Intercom::ResourceNotFound
    end
  end

  def self.create_note(options = {})
    begin
      Intercom::Note.create(options)
    rescue Intercom::MultipleMatchingUsersError, Intercom::ResourceNotFound
    end
  end

  def self.create_user(options = {})
    begin
      Intercom::User.create(options)
    rescue Intercom::MultipleMatchingUsersError, Intercom::ResourceNotFound
    end
  end
end
