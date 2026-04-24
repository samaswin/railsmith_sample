# frozen_string_literal: true

# Demonstrates: input DSL — required, default, in:, transform:, :boolean type.
# Used for create and update where attributes are validated before hitting the model.
class PostFormService < Railsmith::BaseService
  model Post
  domain :blog

  input :title,     String,   required: true
  input :body,      String,   default: nil
  input :status,    String,   default: "draft", in: Post::STATUSES
  input :published, :boolean, default: false
  input :tag_list,  String,   default: nil, transform: ->(v) { v&.strip&.downcase }
end
