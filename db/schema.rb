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

ActiveRecord::Schema[7.0].define(version: 2022_04_24_141829) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.binary "token", null: false
    t.string "context", null: false
    t.string "sent_to"
    t.datetime "created_at", null: false
    t.index ["token", "context"], name: "index_user_tokens_on_token_and_context", unique: true
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_tokens", "users"
end
