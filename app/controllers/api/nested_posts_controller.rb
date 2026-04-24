# frozen_string_literal: true

module Api
  # Demonstrates: PostWithCommentsService — nested has_many writes in one transaction.
  # POST   /api/nested_posts       — create Post + Comments together
  # PUT    /api/nested_posts/:id   — update Post + sync Comments
  # DELETE /api/nested_posts/:id   — destroy Post + cascade to Comments
  class NestedPostsController < ApplicationController
    include Railsmith::ControllerHelpers

    def create
      result = PostWithCommentsService.call(
        action: :create,
        params: nested_params,
        context: request_context
      )
      render_result(result, :created)
    end

    def update
      result = PostWithCommentsService.call(
        action: :update,
        params: nested_params.merge(id: params[:id]),
        context: request_context
      )
      render_result(result, :ok)
    end

    def destroy
      result = PostWithCommentsService.call!(
        action: :destroy,
        params: { id: params[:id] },
        context: request_context
      )
      render json: result.value
    end

    private

    def nested_params
      params.permit(
        :title, :body, :status, :published,
        comments: [:post_id, :author, :body]
      ).to_h.with_indifferent_access
    end

    def request_context
      { current_domain: :blog }
    end

    def render_result(result, success_status)
      if result.success?
        render json: result.value, status: success_status
      else
        render json: result.to_h, status: :unprocessable_entity
      end
    end
  end
end
