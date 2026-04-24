# frozen_string_literal: true

# Demonstrates: eager loading (includes DSL) + has_many with dependent: :nullify and :restrict.
class PostWithTagsService < Railsmith::BaseService
  model Post
  domain :blog

  includes :tags, :comments
end
