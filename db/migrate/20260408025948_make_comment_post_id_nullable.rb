class MakeCommentPostIdNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :comments, :post_id, true
    remove_foreign_key :comments, :posts
  end
end
