# frozen_string_literal: true

class BankingCreateInvestmentThenMedicalInsurancePipeline < Railsmith::Pipeline
  step :create_investment,
       service: Banking::InvestmentService,
       action: :create,
       inputs: { attributes: :investment_attributes }

  step :create_insurance,
       service: Medical::InsuranceService,
       action: :create,
       inputs: { attributes: :insurance_attributes }
end
