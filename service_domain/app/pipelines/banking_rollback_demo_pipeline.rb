# frozen_string_literal: true

class BankingRollbackDemoPipeline < Railsmith::Pipeline
  step :create_investment,
       service: Banking::InvestmentPipelineService,
       action: :create_with_id,
       inputs: { attributes: :investment_attributes },
       rollback: :destroy

  step :force_failure,
       service: Medical::AlwaysFailService,
       action: :fail
end
