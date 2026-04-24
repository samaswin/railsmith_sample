# frozen_string_literal: true

module Billing
  # Demonstrates: cross-domain guard — this service declares domain :billing but
  # when called under a context with current_domain: :blog it emits a
  # cross_domain.warning instrumentation event (warn-only by default).
  class PostReportService < Railsmith::BaseService
    model Post
    domain :billing

    input :id, Integer, required: true

    def report
      result = find_record(Post, params[:id])
      return result if result.failure?

      post = result.value
      Railsmith::Result.success(value: { id: post.id, title: post.title, status: post.status })
    end
  end
end
