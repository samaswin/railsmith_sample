# frozen_string_literal: true

module Api
  # Demonstrates: bulk_create / bulk_update / bulk_destroy via BulkPostService.
  class BulkPostsController < ApplicationController
    include Railsmith::ControllerHelpers

    def create
      result = BulkPostService.call(action: :bulk_create, params: bulk_params, context: request_context)
      render_result(result, :created)
    end

    def update
      result = BulkPostService.call(action: :bulk_update, params: bulk_params, context: request_context)
      render_result(result, :ok)
    end

    def destroy
      result = BulkPostService.call(action: :bulk_destroy, params: bulk_params, context: request_context)
      render_result(result, :ok)
    end

    private

    def bulk_params
      params.permit(items: [:id, :title, :body, :status, :published, { attributes: [:title, :body, :status, :published] }]).to_h.with_indifferent_access
    end

    def render_result(result, success_status)
      if result.success?
        render json: result.value, status: success_status
      else
        render json: result.to_h, status: :unprocessable_entity
      end
    end

    def request_context
      { current_domain: :blog }
    end
  end
end
