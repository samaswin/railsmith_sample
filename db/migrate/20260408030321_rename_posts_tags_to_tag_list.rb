class RenamePostsTagsToTagList < ActiveRecord::Migration[8.1]
  def up
    rename_column :posts, :tags, :tag_list
  end

  def down
    rename_column :posts, :tag_list, :tags
  end
end
