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

ActiveRecord::Schema[8.1].define(version: 2025_11_24_184757) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "question_responses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.text "response_text", null: false
    t.bigint "room_id", null: false
    t.string "session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_responses_on_question_id"
    t.index ["room_id", "question_id", "session_id"], name: "index_question_responses_unique_per_session", unique: true
    t.index ["room_id"], name: "index_question_responses_on_room_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "placeholder"
    t.text "question_text", null: false
    t.datetime "updated_at", null: false
  end

  create_table "response_reactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "question_response_id", null: false
    t.string "session_id"
    t.datetime "updated_at", null: false
    t.index ["question_response_id"], name: "index_response_reactions_on_question_response_id"
  end

  create_table "room_presences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "last_seen"
    t.bigint "room_id", null: false
    t.string "session_id"
    t.datetime "updated_at", null: false
    t.index ["last_seen"], name: "index_room_presences_on_last_seen"
    t.index ["room_id", "session_id"], name: "index_room_presences_on_room_id_and_session_id", unique: true
    t.index ["room_id"], name: "index_room_presences_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "code", limit: 6, null: false
    t.datetime "created_at", null: false
    t.bigint "current_question_id"
    t.string "name", null: false
    t.string "session_id"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_rooms_on_code", unique: true
    t.index ["current_question_id"], name: "index_rooms_on_current_question_id"
    t.index ["session_id"], name: "index_rooms_on_session_id"
  end

  add_foreign_key "question_responses", "questions"
  add_foreign_key "question_responses", "rooms"
  add_foreign_key "response_reactions", "question_responses"
  add_foreign_key "room_presences", "rooms"
  add_foreign_key "rooms", "questions", column: "current_question_id"
end
