# frozen_string_literal: true

# Demonstrates: bulk_create / bulk_update / bulk_destroy.
# No input DSL — bulk items are processed item-by-item; input resolution
# runs on the outer params (which only contains :items + :transaction_mode).
#
# Params shape for bulk_create:
#   { transaction_mode: :best_effort, items: [{ title: "A" }, { title: "B" }] }
# Params shape for bulk_update:
#   { transaction_mode: :best_effort, items: [{ id: 1, attributes: { title: "A2" } }] }
# Params shape for bulk_destroy:
#   { transaction_mode: :best_effort, items: [{ id: 1 }, { id: 2 }] }
#
# Result shape: { summary: { total:, success_count:, ... }, items: [...] }
class BulkPostService < Railsmith::BaseService
  model Post
  domain :blog
end
