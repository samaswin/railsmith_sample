# frozen_string_literal: true

# Demonstrates: dependent: :nullify — FK on children is nullified when parent is destroyed.
# Note: comments.post_id must be nullable for this to work.
class PostNullifyService < Railsmith::BaseService
  model Post
  domain :blog

  has_many :comments, service: CommentService, dependent: :nullify
end
