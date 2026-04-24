class CreatePostMetas < ActiveRecord::Migration[8.1]
  def change
    create_table :post_metas do |t|
      t.bigint :post_id
      t.string :summary

      t.timestamps
    end

    add_index :post_metas, :post_id
  end
end
