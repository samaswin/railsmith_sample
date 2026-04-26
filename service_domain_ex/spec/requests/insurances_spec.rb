# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Insurances", type: :request do
  it "renders index and show, and supports create/update/destroy" do
    get insurances_path
    expect(response).to have_http_status(:ok)

    post insurances_path, params: {
      insurance: {
        provider: "Acme",
        policy_number: "POL-123",
        premium_cents: 1500,
        starts_on: "2026-01-01",
        ends_on: "2026-12-31"
      }
    }
    expect(response).to have_http_status(:found)

    insurance = Insurance.order(:created_at).last
    expect(insurance).to be_present

    get insurance_path(insurance)
    expect(response).to have_http_status(:ok)

    patch insurance_path(insurance), params: { insurance: { provider: "BetterCo" } }
    expect(response).to have_http_status(:found)
    expect(insurance.reload.provider).to eq("BetterCo")

    delete insurance_path(insurance)
    expect(response).to have_http_status(:found)
    expect(Insurance.where(id: insurance.id)).not_to exist
  end
end
