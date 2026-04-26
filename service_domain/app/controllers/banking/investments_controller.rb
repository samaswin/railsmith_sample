# frozen_string_literal: true

module Banking
  class InvestmentsController < ApplicationController
    before_action :set_investment, only: %i[show edit update destroy]

    def index
      result = Banking::InvestmentService.call(action: :list, context: { current_domain: :banking })
      @investments = result.success? ? result.value.sort_by(&:created_at).reverse : []
    end

    def show; end

    def new
      @investment = Banking::Investment.new
    end

    def edit; end

    def create
      result = Banking::InvestmentService.call(
        action: :create,
        params: { attributes: investment_params.to_h },
        context: { current_domain: :banking }
      )

      if result.success?
        redirect_to banking_investment_path(result.value), notice: "Investment created."
        return
      end

      @investment = Banking::Investment.new(investment_params)
      @investment.errors.add(:base, result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
      render :new, status: :unprocessable_entity
    end

    def update
      result = Banking::InvestmentService.call(
        action: :update,
        params: { id: @investment.id, attributes: investment_params.to_h },
        context: { current_domain: :banking }
      )

      if result.success?
        redirect_to banking_investment_path(result.value), notice: "Investment updated."
        return
      end

      @investment.assign_attributes(investment_params)
      @investment.errors.add(:base, result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
      render :edit, status: :unprocessable_entity
    end

    def destroy
      result = Banking::InvestmentService.call(
        action: :destroy,
        params: { id: @investment.id },
        context: { current_domain: :banking }
      )

      if result.success?
        redirect_to banking_investments_path, notice: "Investment deleted."
      else
        redirect_to banking_investment_path(@investment),
                    alert: (result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
      end
    end

    private

    def set_investment
      result = Banking::InvestmentService.call(
        action: :find,
        params: { id: params[:id] },
        context: { current_domain: :banking }
      )

      raise ActiveRecord::RecordNotFound unless result.success?

      @investment = result.value
    end

    def investment_params
      params.require(:banking_investment).permit(:name, :kind, :amount_cents, :purchased_on)
    end
  end
end
