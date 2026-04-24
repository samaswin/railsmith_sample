# frozen_string_literal: true

# SCENARIO: Direct model access with no service delegation.
# Expected: DirectModelAccessChecker + MissingServiceUsageChecker both fire on each action.
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.create!(post_params)
  end

  def destroy
    Post.find(params[:id]).destroy
  end

  private

  # SCENARIO: Private methods are ignored by MissingServiceUsageChecker even if they access models.
  def post_params
    Post.find(1) # skipped — private section
    params.require(:post).permit(:title, :body)
  end
end
