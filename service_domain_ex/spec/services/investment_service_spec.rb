# frozen_string_literal: true

require "rails_helper"

RSpec.describe InvestmentService do
  describe ".call" do
    it "creates, finds, updates, lists, and destroys an investment" do
      create_result = described_class.call(
        action: :create,
        params: {
          attributes: {
            name: "Index Fund",
            kind: "mutual_fund",
            amount_cents: 50_00,
            purchased_on: Date.new(2026, 2, 15)
          }
        },
        context: { current_domain: :investment }
      )

      expect(create_result).to be_success
      investment = create_result.value
      expect(investment).to be_a(Investment)
      expect(investment.name).to eq("Index Fund")

      find_result = described_class.call(
        action: :find,
        params: { id: investment.id },
        context: { current_domain: :investment }
      )
      expect(find_result).to be_success
      expect(find_result.value.id).to eq(investment.id)

      update_result = described_class.call(
        action: :update,
        params: { id: investment.id, attributes: { kind: "etf" } },
        context: { current_domain: :investment }
      )
      expect(update_result).to be_success
      expect(update_result.value.kind).to eq("etf")

      list_result = described_class.call(action: :list, context: { current_domain: :investment })
      expect(list_result).to be_success
      expect(list_result.value.map(&:id)).to include(investment.id)

      destroy_result = described_class.call(
        action: :destroy,
        params: { id: investment.id },
        context: { current_domain: :investment }
      )
      expect(destroy_result).to be_success
      expect(Investment.where(id: investment.id)).not_to exist
    end
  end
end
