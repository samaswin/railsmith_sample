class CreateInvestments < ActiveRecord::Migration[8.1]
  def change
    create_table :investments do |t|
      t.string :name, null: false
      t.string :kind, null: false
      t.integer :amount_cents, null: false, default: 0
      t.date :purchased_on

      t.timestamps
    end

    add_index :investments, :kind
    add_index :investments, %i[name kind]
  end
end
