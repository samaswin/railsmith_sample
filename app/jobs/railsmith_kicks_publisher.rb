# frozen_string_literal: true

# Kicks-style publisher for Railsmith async nested writes.
#
# Kicks (the maintained fork of Sneakers) uses a publish/subscribe pattern.
# This class acts as a publisher that enqueues work onto a message broker.
#
# Wire it in via:
#   config.async_job_class = RailsmithKicksPublisher
#   config.async_enqueuer  = ->(job_class, payload) { job_class.publish(payload) }
#
# In a real app this would publish to RabbitMQ/AMQP via Kicks/Sneakers.
# For the sample app we simulate it with an in-memory queue.
class RailsmithKicksPublisher
  PUBLISHED_MESSAGES = []

  def self.publish(payload)
    PUBLISHED_MESSAGES << payload
    "msg-#{SecureRandom.hex(8)}"
  end

  def self.publish_async(payload)
    publish(payload)
  end

  # Drain the in-memory queue and process all pending messages.
  # Used in tests to synchronously execute enqueued work.
  def self.drain!
    while (payload = PUBLISHED_MESSAGES.shift)
      payload = payload.transform_keys(&:to_sym) if payload.is_a?(Hash)

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

  # Clear the queue without processing.
  def self.clear!
    PUBLISHED_MESSAGES.clear
  end
end
