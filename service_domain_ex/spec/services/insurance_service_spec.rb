# frozen_string_literal: true

require "rails_helper"

RSpec.describe InsuranceService do
  describe ".call" do
    it "creates, finds, updates, lists, and destroys an insurance" do
      create_result = described_class.call(
        action: :create,
        params: {
          attributes: {
            provider: "Acme",
            policy_number: "POL-123",
            premium_cents: 1500,
            starts_on: Date.new(2026, 1, 1),
            ends_on: Date.new(2026, 12, 31)
          }
        },
        context: { current_domain: :insurance }
      )

      expect(create_result).to be_success
      insurance = create_result.value
      expect(insurance).to be_a(Insurance)
      expect(insurance.provider).to eq("Acme")

      find_result = described_class.call(
        action: :find,
        params: { id: insurance.id },
        context: { current_domain: :insurance }
      )
      expect(find_result).to be_success
      expect(find_result.value.id).to eq(insurance.id)

      update_result = described_class.call(
        action: :update,
        params: { id: insurance.id, attributes: { provider: "BetterCo" } },
        context: { current_domain: :insurance }
      )
      expect(update_result).to be_success
      expect(update_result.value.provider).to eq("BetterCo")

      list_result = described_class.call(action: :list, context: { current_domain: :insurance })
      expect(list_result).to be_success
      expect(list_result.value.map(&:id)).to include(insurance.id)

      destroy_result = described_class.call(
        action: :destroy,
        params: { id: insurance.id },
        context: { current_domain: :insurance }
      )
      expect(destroy_result).to be_success
      expect(Insurance.where(id: insurance.id)).not_to exist
    end
  end
end
