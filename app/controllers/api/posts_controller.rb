# frozen_string_literal: true

module Api
  # Demonstrates: Railsmith::ControllerHelpers rescuing Railsmith::Failure and
  # rendering the right HTTP status automatically.
  # All model access is routed through PostService — no direct AR calls here.
  class PostsController < ApplicationController
    include Railsmith::ControllerHelpers

    def index
      result = PostService.call(action: :list, context: request_context)
      render json: result.value
    end

    def show
      result = PostService.call(action: :find, params: { id: params[:id] }, context: request_context)
      if result.success?
        render json: result.value
      else
        render json: result.to_h, status: :not_found
      end
    end

    def create
      result = PostService.call(action: :create, params: post_attributes_params, context: request_context)
      if result.success?
        render json: result.value, status: :created
      else
        render json: result.to_h, status: :unprocessable_entity
      end
    end

    def update
      result = PostService.call(
        action: :update,
        params: { id: params[:id], attributes: post_params },
        context: request_context
      )
      if result.success?
        render json: result.value
      else
        render json: result.to_h, status: :unprocessable_entity
      end
    end

    def destroy
      # Demonstrates call! — raises Railsmith::Failure on error, caught by ControllerHelpers.
      result = PostService.call!(action: :destroy, params: { id: params[:id] }, context: request_context)
      render json: result.value
    end

    private

    def post_params
      params.require(:post).permit(:title, :body, :status, :published, :tags)
    end

    def post_attributes_params
      { attributes: post_params }
    end

    def request_context
      { current_domain: :blog, current_user_id: nil }
    end
  end
end
