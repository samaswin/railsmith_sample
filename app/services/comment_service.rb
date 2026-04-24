# frozen_string_literal: true

# No input DSL — used as a nested child service in PostWithCommentsService.
# The nested writer injects the FK (post_id) directly into attributes and
# cascade destroy calls :destroy with { id: record_id }; having required inputs
# would conflict with those call shapes.
# Model validations enforce presence of author and body.
class CommentService < Railsmith::BaseService
  model Comment
  domain :blog
end
