# frozen_string_literal: true

# Demonstrates: Phase 2 lifecycle hooks.
#
# Shows three hook patterns on a single service:
# - +before+ hook: capture an audit trail of every mutating call
# - +after+ hook: publish a domain event when writes succeed
# - +around+ hook: record a timing sample for observability
#
# All three hooks are additive — removing them would leave a perfectly
# ordinary CRUD service behind. See docs/hooks.md for the full guide.
class AuditedPostService < Railsmith::BaseService
  model Post
  domain :blog

  # Cheap in-memory sinks so the sample app can show the hooks firing
  # without pulling in a full observability stack. A production service
  # would point these at Kafka / StatsD / Datadog / etc.
  AUDIT_TRAIL = []
  EVENT_LOG   = []
  TIMINGS     = []

  before :create, :update, :destroy, name: :audit_log do
    AUDIT_TRAIL << {
      service: self.class.name,
      actor:   context[:actor_id],
      tenant:  context[:tenant_id],
      at:      Time.now
    }
  end

  after :create, :update do |result|
    next unless result.success?

    EVENT_LOG << {
      topic:   "post.written",
      payload: result.value.respond_to?(:id) ? { id: result.value.id } : result.value
    }
  end

  around :create do |action|
    t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = action.call
    TIMINGS << (Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0)
    result
  end
end
