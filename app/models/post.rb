# frozen_string_literal: true

class Post < ApplicationRecord
  STATUSES = %w[draft published archived].freeze

  has_many :comments, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_one  :post_meta, dependent: :destroy

  # Keep the sample app compatible with both schema variants:
  # - older: posts.tags
  # - newer: posts.tag_list
  alias_attribute :tag_list, :tags if column_names.include?("tags") && !column_names.include?("tag_list")

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
end
