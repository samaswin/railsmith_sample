# frozen_string_literal: true

class PostMeta < ApplicationRecord
  # Rails inflections can treat "meta" as uncountable, which would make AR look
  # for a singular table name ("post_meta"). Our schema uses the conventional
  # pluralized table name.
  self.table_name = "post_metas"

  belongs_to :post, optional: true

  validates :summary, presence: true
end
