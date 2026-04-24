# frozen_string_literal: true

# Demonstrates: dependent: :restrict — destroy fails when children exist.
class PostRestrictService < Railsmith::BaseService
  model Post
  domain :blog

  has_many :comments, service: CommentService, dependent: :restrict
end
