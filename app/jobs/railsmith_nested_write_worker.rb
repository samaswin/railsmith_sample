# frozen_string_literal: true

# Native Sidekiq worker for Railsmith async nested writes.
#
# This bypasses ActiveJob and calls Sidekiq directly. Use this when you
# want native Sidekiq features (e.g. fine-grained retry, batches) without
# the ActiveJob abstraction layer.
#
# Wire it in via:
#   config.async_job_class = RailsmithNestedWriteWorker
#
# The enqueuer detects that the class responds to `perform_async` and
# uses the Sidekiq enqueue path.
class RailsmithNestedWriteWorker
  include Sidekiq::Worker

  sidekiq_options queue: "railsmith_nested_writes", retry: 3

  def perform(payload)
    payload = payload.transform_keys(&:to_sym)

    service_klass = Object.const_get(payload[:service_class])
    parent_record = service_klass.model.find(payload[:parent_id])
    railsmith_context = Railsmith::Context.build(payload[:context])

    service_klass
      .new(params: {}, context: railsmith_context)
      .send(
        :perform_nested_write_for_job,
        payload[:association].to_sym,
        parent_record,
        payload[:nested_params],
        payload[:mode].to_sym
      )
  end
end
