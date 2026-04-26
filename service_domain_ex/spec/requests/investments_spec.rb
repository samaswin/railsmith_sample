# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Investments", type: :request do
  it "renders index and show, and supports create/update/destroy" do
    get investments_path
    expect(response).to have_http_status(:ok)

    post investments_path, params: {
      investment: {
        name: "Index Fund",
        kind: "mutual_fund",
        amount_cents: 5000,
        purchased_on: "2026-02-15"
      }
    }
    expect(response).to have_http_status(:found)

    investment = Investment.order(:created_at).last
    expect(investment).to be_present

    get investment_path(investment)
    expect(response).to have_http_status(:ok)

    patch investment_path(investment), params: { investment: { kind: "etf" } }
    expect(response).to have_http_status(:found)
    expect(investment.reload.kind).to eq("etf")

    delete investment_path(investment)
    expect(response).to have_http_status(:found)
    expect(Investment.where(id: investment.id)).not_to exist
  end
end
