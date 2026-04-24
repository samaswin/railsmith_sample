# frozen_string_literal: true

# Demonstrates: named hook inheritance + skip_hook.
#
# +RateLimitedService+ adds a named +:rate_limit+ around hook to the
# standard +BaseService+. Subclasses that represent trusted internal
# callers can opt out with +skip_hook :rate_limit+ without having to
# re-declare anything else.
class RateLimitedService < Railsmith::BaseService
  RATE_LIMIT_CALLS = []

  around :create, :update, :destroy, name: :rate_limit do |action|
    RATE_LIMIT_CALLS << {
      service: self.class.name,
      actor:   context[:actor_id]
    }
    action.call
  end
end

# Internal post publisher — bypasses the rate limiter.
class InternalPostService < RateLimitedService
  model Post
  domain :blog

  skip_hook :rate_limit
end
