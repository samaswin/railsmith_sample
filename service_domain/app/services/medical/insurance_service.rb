# frozen_string_literal: true

module Medical
  class InsuranceService < Railsmith::BaseService
    domain :medical
    model(Medical::Insurance)
  end
end
