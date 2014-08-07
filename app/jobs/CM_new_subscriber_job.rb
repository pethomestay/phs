require 'createsend'

class CMNewSubscriberJob
  include SuckerPunch::Job

  def perform(user)
    # Authenticate params
    auth = {
      api_key: ENV['CM_API_KEY'],
    }
    # Add to list All Users
    # List ID: b153ae044ddaa3a1ddbe5cbd29a0b615
    custom_fields = {
      'Joined'    => user.created_at.to_formatted_s(:year_month_day),
      'Homestay?' => user.homestay.present? ? 'Yes' : 'No',
      'Active'    => user.active,
    }
    CreateSend::Subscriber.add(
      auth,
      'b153ae044ddaa3a1ddbe5cbd29a0b615',
      user.email,
      user.name,
      parse(custom_fields),
      false,
    )
  end

  private
  # { State: 'VIC' } -> [{ Key: 'State', Value: 'VIC' }]
  def parse(fields)
    parsed = []
    fields.each do |key, val|
      parsed << { Key: key.to_s, Value: val }
    end
    parsed
  end
end
