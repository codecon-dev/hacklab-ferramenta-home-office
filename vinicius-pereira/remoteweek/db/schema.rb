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

ActiveRecord::Schema[7.1].define(version: 2025_11_29_125114) do
  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "standups", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.date "date"
    t.text "yesterday"
    t.text "today"
    t.text "blockers"
    t.integer "commits_count"
    t.integer "support_tickets_resolved"
    t.text "extra_notes"
    t.json "raw_integrations_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_standups_on_organization_id"
    t.index ["user_id"], name: "index_standups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "organization_id", null: false
    t.string "role"
    t.string "github_username"
    t.string "support_tool_username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  create_table "weekly_reports", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.date "week_start"
    t.date "week_end"
    t.datetime "generated_at"
    t.json "report_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_weekly_reports_on_organization_id"
  end

  add_foreign_key "standups", "organizations"
  add_foreign_key "standups", "users"
  add_foreign_key "users", "organizations"
  add_foreign_key "weekly_reports", "organizations"
end
