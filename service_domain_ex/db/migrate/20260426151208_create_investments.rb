class CreateInvestments < ActiveRecord::Migration[8.1]
  def change
    create_table :investments do |t|
      t.string :name
      t.string :kind
      t.integer :amount_cents
      t.date :purchased_on

      t.timestamps
    end
  end
end
