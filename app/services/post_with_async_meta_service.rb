# frozen_string_literal: true

# Demonstrates: async nested writes via `async: true` on has_one.
#
# When a post is created with nested post_meta, the meta write is
# enqueued as a background job AFTER the parent transaction commits.
class PostWithAsyncMetaService < Railsmith::BaseService
  model Post
  domain :blog

  has_one :post_meta, service: PostMetaService, async: true
end
