class CreateInsurances < ActiveRecord::Migration[8.1]
  def change
    create_table :insurances do |t|
      t.string :provider, null: false
      t.string :policy_number, null: false
      t.integer :premium_cents, null: false, default: 0
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end

    add_index :insurances, :policy_number, unique: true
    add_index :insurances, :provider
  end
end
