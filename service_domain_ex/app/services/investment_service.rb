# frozen_string_literal: true

class InvestmentService < Railsmith::BaseService
  domain :investment
  model(::Investment)
end
