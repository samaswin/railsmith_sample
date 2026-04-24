class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body
      t.string :status, null: false, default: "draft"
      t.boolean :published, null: false, default: false

      t.timestamps
    end
  end
end
