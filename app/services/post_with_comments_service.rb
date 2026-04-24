# frozen_string_literal: true

# Demonstrates: has_many nested writes (dependent: :destroy).
# create  — builds Post + nested Comments in one transaction
# update  — updates Post + syncs Comments
# destroy — cascades destroy to Comments via dependent: :destroy
#
# No input DSL here — inputs conflict with find/destroy call shapes
# (the resolver would require :title even for destroy params { id: X }).
# Model validations on Post enforce presence of title instead.
class PostWithCommentsService < Railsmith::BaseService
  model Post
  domain :blog

  has_many :comments, service: CommentService, dependent: :destroy
end
