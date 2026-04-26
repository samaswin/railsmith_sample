# frozen_string_literal: true

class RenameInsurancesAndInvestmentsForDomains < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_insurances do |t|
      t.string :provider, null: false
      t.string :policy_number, null: false
      t.integer :premium_cents, null: false, default: 0
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end

    add_index :medical_insurances, :policy_number, unique: true
    add_index :medical_insurances, :provider

    create_table :banking_investments do |t|
      t.string :name, null: false
      t.string :kind, null: false
      t.integer :amount_cents, null: false, default: 0
      t.date :purchased_on

      t.timestamps
    end

    add_index :banking_investments, :kind
    add_index :banking_investments, %i[name kind]

    reversible do |dir|
      dir.up do
        safety_assured do
          execute <<~SQL.squish
            INSERT INTO medical_insurances (provider, policy_number, premium_cents, starts_on, ends_on, created_at, updated_at)
            SELECT provider, policy_number, premium_cents, starts_on, ends_on, created_at, updated_at
            FROM insurances
          SQL

          execute <<~SQL.squish
            INSERT INTO banking_investments (name, kind, amount_cents, purchased_on, created_at, updated_at)
            SELECT name, kind, amount_cents, purchased_on, created_at, updated_at
            FROM investments
          SQL
        end
      end
    end

    safety_assured do
      drop_table :insurances
      drop_table :investments
    end
  end
end
