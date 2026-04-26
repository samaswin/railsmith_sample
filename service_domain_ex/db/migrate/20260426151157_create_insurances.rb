class CreateInsurances < ActiveRecord::Migration[8.1]
  def change
    create_table :insurances do |t|
      t.string :provider
      t.string :policy_number
      t.integer :premium_cents
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end
  end
end
