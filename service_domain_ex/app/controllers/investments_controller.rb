# frozen_string_literal: true

class InvestmentsController < ApplicationController
  before_action :set_investment, only: %i[show edit update destroy]

  def index
    result = InvestmentService.call(action: :list, context: { current_domain: :investment })
    @investments = result.success? ? result.value.sort_by(&:created_at).reverse : []
  end

  def show; end

  def new
    @investment = Investment.new
  end

  def edit; end

  def create
    result = InvestmentService.call(
      action: :create,
      params: { attributes: investment_params.to_h },
      context: { current_domain: :investment }
    )

    if result.success?
      redirect_to investment_path(result.value), notice: "Investment created."
      return
    end

    @investment = Investment.new(investment_params)
    @investment.errors.add(:base, result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
    render :new, status: :unprocessable_entity
  end

  def update
    result = InvestmentService.call(
      action: :update,
      params: { id: @investment.id, attributes: investment_params.to_h },
      context: { current_domain: :investment }
    )

    if result.success?
      redirect_to investment_path(result.value), notice: "Investment updated."
      return
    end

    @investment.assign_attributes(investment_params)
    @investment.errors.add(:base, result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
    render :edit, status: :unprocessable_entity
  end

  def destroy
    result = InvestmentService.call(
      action: :destroy,
      params: { id: @investment.id },
      context: { current_domain: :investment }
    )

    if result.success?
      redirect_to investments_path, notice: "Investment deleted."
    else
      redirect_to investment_path(@investment),
                  alert: (result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
    end
  end

  private

  def set_investment
    result = InvestmentService.call(
      action: :find,
      params: { id: params[:id] },
      context: { current_domain: :investment }
    )

    raise ActiveRecord::RecordNotFound unless result.success?

    @investment = result.value
  end

  def investment_params
    params.require(:investment).permit(:name, :kind, :amount_cents, :purchased_on)
  end
end
