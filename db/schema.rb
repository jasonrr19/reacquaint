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

ActiveRecord::Schema[7.1].define(version: 2025_02_24_085215) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "compatible_responses", force: :cascade do |t|
    t.text "notes"
    t.boolean "approved", default: false
    t.float "score"
    t.bigint "submission_id", null: false
    t.bigint "selected_prerequisite_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["selected_prerequisite_id"], name: "index_compatible_responses_on_selected_prerequisite_id"
    t.index ["submission_id"], name: "index_compatible_responses_on_submission_id"
  end

  create_table "prerequisites", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "selected_prerequisites", force: :cascade do |t|
    t.text "description"
    t.boolean "approved", default: false
    t.bigint "tender_id", null: false
    t.bigint "prerequisite_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prerequisite_id"], name: "index_selected_prerequisites_on_prerequisite_id"
    t.index ["tender_id"], name: "index_selected_prerequisites_on_tender_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.boolean "published", default: false
    t.boolean "shortlisted", default: false
    t.bigint "user_id", null: false
    t.bigint "tender_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tender_id"], name: "index_submissions_on_tender_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "tenders", force: :cascade do |t|
    t.text "synopsis"
    t.string "title"
    t.boolean "published", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tenders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "compatible_responses", "selected_prerequisites"
  add_foreign_key "compatible_responses", "submissions"
  add_foreign_key "selected_prerequisites", "prerequisites"
  add_foreign_key "selected_prerequisites", "tenders"
  add_foreign_key "submissions", "tenders"
  add_foreign_key "submissions", "users"
  add_foreign_key "tenders", "users"
end
