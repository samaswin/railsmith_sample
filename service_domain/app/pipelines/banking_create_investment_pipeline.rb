# frozen_string_literal: true

class BankingCreateInvestmentPipeline < Railsmith::Pipeline
  step :create_investment,
       service: Banking::InvestmentService,
       action: :create,
       inputs: { attributes: :investment_attributes }
end
