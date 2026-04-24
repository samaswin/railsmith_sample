# frozen_string_literal: true

class Comment < ApplicationRecord
  # Needed for dependent: :nullify scenarios in the sample app.
  belongs_to :post, optional: true

  validates :author, presence: true
  validates :body, presence: true
end
