class AddTagsToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :tags, :string
  end
end
