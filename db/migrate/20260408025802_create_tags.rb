class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.references :post, null: false, foreign_key: true
      t.string :label

      t.timestamps
    end
  end
end
