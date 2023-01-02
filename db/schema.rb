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

ActiveRecord::Schema[7.0].define(version: 7) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "value", null: false
    t.uuid "participant_id", null: false
    t.uuid "guessed_participant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guessed_participant_id"], name: "index_answers_on_guessed_participant_id", unique: true
    t.index ["participant_id"], name: "index_answers_on_participant_id", unique: true
  end

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id", null: false
    t.uuid "round_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "round_id"], name: "index_participants_on_player_id_and_round_id", unique: true
    t.index ["player_id"], name: "index_participants_on_player_id"
    t.index ["round_id"], name: "index_participants_on_round_id"
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "user_id", null: false
    t.uuid "game_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_players_on_deleted_at"
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["name", "game_id", "deleted_at"], name: "index_players_on_name_and_game_id_and_deleted_at", unique: true
    t.index ["user_id", "game_id", "deleted_at"], name: "index_players_on_user_id_and_game_id_and_deleted_at", unique: true
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "rounds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "game_id", null: false
    t.uuid "guesser_id", null: false
    t.integer "order", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.text "question", null: false
    t.boolean "hide_answers", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "order"], name: "index_rounds_on_game_id_and_order", unique: true
    t.index ["game_id"], name: "index_rounds_on_game_id"
    t.index ["guesser_id"], name: "index_rounds_on_guesser_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "last_seen_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "participants"
  add_foreign_key "answers", "participants", column: "guessed_participant_id"
  add_foreign_key "participants", "players"
  add_foreign_key "participants", "rounds"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "players", column: "guesser_id"
end
