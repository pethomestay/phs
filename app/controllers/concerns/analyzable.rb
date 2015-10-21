module Concerns::Analyzable

  private

    def convert_visitor_to_user(anonymous_id, user_id)
      Analytics.alias(previous_id: anonymous_id, user_id: user_id)
    end

    def record_converted_visitor(user_id, traits = {})
      Analytics.identify(user_id: user_id, traits: traits)
    end

    def track(distinct_id, event, properties = {})
      Analytics.track(distinct_id, event, properties)
    end

end
