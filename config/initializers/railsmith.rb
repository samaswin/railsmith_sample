# frozen_string_literal: true

Railsmith.configure do |config|
  # Emit instrumentation when a service runs outside its declared domain.
  config.warn_on_cross_domain_calls = true

  # Raise on cross-domain calls (set true to enforce strictly).
  config.strict_mode = false

  # Allowlist specific cross-domain pairings that are intentional.
  # e.g. billing reading blog posts for reporting is allowed.
  # context_domain: :blog calls billing service → allowlist from: :blog, to: :billing
  config.cross_domain_allowlist = [
    { from: :blog, to: :billing }
  ]

  # Fail rake arch_check when violations are found (set true for CI).
  config.fail_on_arch_violations = false

  # Custom coercion: :money type converts to integer cents.
  config.register_coercion(:money, ->(v) { (v.to_f * 100).round })

  # ── Async nested association writes ──────────────────────────────────────────
  #
  # Default: ActiveJob via Railsmith::AsyncNestedWriteJob.
  # Works with any ActiveJob backend: SolidQueue, GoodJob, DelayedJob,
  # Sidekiq (via ActiveJob adapter), etc.
  config.async_job_class = Railsmith::AsyncNestedWriteJob

  # Native Sidekiq (no ActiveJob wrapper):
  #   config.async_job_class = RailsmithNestedWriteWorker
  #
  # Kicks/Sneakers publisher (message broker):
  #   config.async_job_class = RailsmithKicksPublisher
  #   config.async_enqueuer  = ->(job_class, payload) { job_class.publish(payload) }
end
