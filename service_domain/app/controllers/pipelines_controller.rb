# frozen_string_literal: true

class PipelinesController < ApplicationController
  PIPELINES = {
    "Banking: Create Investment" => "BankingCreateInvestmentPipeline",
    "Banking -> Medical: Create Investment then Insurance" => "BankingCreateInvestmentThenMedicalInsurancePipeline",
    "Rollback demo: create investment then fail" => "BankingRollbackDemoPipeline"
  }.freeze

  def index
    @pipelines = PIPELINES
  end

  def run
    pipeline = PIPELINES.fetch(params.fetch(:pipeline_key)).constantize
    context_domain = params.fetch(:context_domain).to_sym

    cross_domain_warnings = []
    callback = lambda do |_name, _start, _finish, _id, payload|
      cross_domain_warnings << payload
    end

    result = ActiveSupport::Notifications.subscribed(callback, "cross_domain.warning.railsmith") do
      pipeline.call(params: pipeline_params, context: { current_domain: context_domain })
    end

    @pipelines = PIPELINES
    @selected_pipeline_key = params[:pipeline_key]
    @context_domain = context_domain
    @result = result
    @submitted_params = pipeline_params
    @cross_domain_warnings = cross_domain_warnings

    render :index
  rescue KeyError, ActionController::ParameterMissing => e
    redirect_to pipelines_path, alert: e.message
  end

  private

  def pipeline_params
    {
      investment_attributes: params.fetch(:investment_attributes, {}).permit(:name, :kind, :amount_cents, :purchased_on).to_h,
      insurance_attributes: params.fetch(:insurance_attributes, {}).permit(:provider, :policy_number, :premium_cents, :starts_on, :ends_on).to_h
    }.compact
  end
end
