class InsurancesController < ApplicationController
  before_action :set_insurance, only: %i[show update destroy]

  def index
    render json: Insurance.order(created_at: :desc)
  end

  def show
    render json: @insurance
  end

  def create
    insurance = Insurance.new(insurance_params)

    if insurance.save
      render json: insurance, status: :created
    else
      render json: { errors: insurance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @insurance.update(insurance_params)
      render json: @insurance
    else
      render json: { errors: @insurance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @insurance.destroy!
    head :no_content
  end

  private

  def set_insurance
    @insurance = Insurance.find(params[:id])
  end

  def insurance_params
    params.require(:insurance).permit(:provider, :policy_number, :premium_cents, :starts_on, :ends_on)
  end
end
