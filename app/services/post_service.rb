# frozen_string_literal: true

# Demonstrates: model + domain declaration.
# Handles find / list / destroy — no input DSL so :id is not filtered from params.
class PostService < Railsmith::BaseService
  model Post
  domain :blog
end
