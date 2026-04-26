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

ActiveRecord::Schema[8.1].define(version: 2026_04_26_151208) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "insurances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "ends_on"
    t.string "policy_number"
    t.integer "premium_cents"
    t.string "provider"
    t.date "starts_on"
    t.datetime "updated_at", null: false
  end

  create_table "investments", force: :cascade do |t|
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.string "kind"
    t.string "name"
    t.date "purchased_on"
    t.datetime "updated_at", null: false
  end
end
