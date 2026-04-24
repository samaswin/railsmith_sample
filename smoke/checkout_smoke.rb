# frozen_string_literal: true

require_relative "../../lib/railsmith"

# Minimal stand-in services (no ActiveRecord).
class SampleCartService < Railsmith::BaseService
  def validate
    return Railsmith::Result.failure(message: "missing cart_id") if params[:cart_id].nil?

    Railsmith::Result.success(value: { cart_total: 42, user_id: params[:user_id] })
  end
end

class SampleInventoryService < Railsmith::BaseService
  def reserve
    Railsmith::Result.success(value: { reservation_id: "rez-1" })
  end
end

class SampleCheckoutPipeline < Railsmith::Pipeline
  step :validate_cart, service: SampleCartService, action: :validate
  step :reserve_inventory, service: SampleInventoryService, action: :reserve
end

result = SampleCheckoutPipeline.call(params: { cart_id: 1, user_id: 2 }, context: Railsmith::Context.build(nil))
unless result.success? && result.value[:reservation_id] == "rez-1"
  warn "Smoke failed: #{result.inspect}"
  exit 1
end

puts "checkout_smoke: ok (#{result.value.inspect})"
