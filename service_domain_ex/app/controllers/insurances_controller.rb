# frozen_string_literal: true

class InsurancesController < ApplicationController
  before_action :set_insurance, only: %i[show edit update destroy]

  def index
    result = InsuranceService.call(action: :list, context: { current_domain: :insurance })
    @insurances = result.success? ? result.value.sort_by(&:created_at).reverse : []
  end

  def show; end

  def new
    @insurance = Insurance.new
  end

  def edit; end

  def create
    result = InsuranceService.call(
      action: :create,
      params: { attributes: insurance_params.to_h },
      context: { current_domain: :insurance }
    )

    if result.success?
      redirect_to insurance_path(result.value), notice: "Insurance created."
      return
    end

    @insurance = Insurance.new(insurance_params)
    @insurance.errors.add(:base, result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
    render :new, status: :unprocessable_entity
  end

  def update
    result = InsuranceService.call(
      action: :update,
      params: { id: @insurance.id, attributes: insurance_params.to_h },
      context: { current_domain: :insurance }
    )

    if result.success?
      redirect_to insurance_path(result.value), notice: "Insurance updated."
      return
    end

    @insurance.assign_attributes(insurance_params)
    @insurance.errors.add(:base, result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
    render :edit, status: :unprocessable_entity
  end

  def destroy
    result = InsuranceService.call(
      action: :destroy,
      params: { id: @insurance.id },
      context: { current_domain: :insurance }
    )

    if result.success?
      redirect_to insurances_path, notice: "Insurance deleted."
    else
      redirect_to insurance_path(@insurance),
                  alert: (result.error.respond_to?(:message) ? result.error.message : result.error.to_s)
    end
  end

  private

  def set_insurance
    result = InsuranceService.call(
      action: :find,
      params: { id: params[:id] },
      context: { current_domain: :insurance }
    )

    raise ActiveRecord::RecordNotFound unless result.success?

    @insurance = result.value
  end

  def insurance_params
    params.require(:insurance).permit(:provider, :policy_number, :premium_cents, :starts_on, :ends_on)
  end
end
