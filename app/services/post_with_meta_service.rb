# frozen_string_literal: true

# Demonstrates: has_one nested write (dependent: :destroy).
# create  — builds Post + nested PostMeta in one transaction
# update  — updates Post + syncs PostMeta (create, update, or _destroy)
# destroy — cascades destroy to PostMeta via dependent: :destroy
class PostWithMetaService < Railsmith::BaseService
  model Post
  domain :blog

  has_one :post_meta, service: PostMetaService, dependent: :destroy
end
