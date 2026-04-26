# frozen_string_literal: true

module Banking
  class InvestmentService < Railsmith::BaseService
    domain :banking
    model(Banking::Investment)
  end
end
