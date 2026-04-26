# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_26_192500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "banking_investments", force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.string "name", null: false
    t.date "purchased_on"
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_banking_investments_on_kind"
    t.index ["name", "kind"], name: "index_banking_investments_on_name_and_kind"
  end

  create_table "medical_insurances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "ends_on"
    t.string "policy_number", null: false
    t.integer "premium_cents", default: 0, null: false
    t.string "provider", null: false
    t.date "starts_on"
    t.datetime "updated_at", null: false
    t.index ["policy_number"], name: "index_medical_insurances_on_policy_number", unique: true
    t.index ["provider"], name: "index_medical_insurances_on_provider"
  end
end
