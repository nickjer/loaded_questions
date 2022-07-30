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

ActiveRecord::Schema[7.0].define(version: 2021_10_19_215845) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "value", null: false
    t.uuid "player_id", null: false
    t.uuid "round_id", null: false
    t.uuid "guessed_player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guessed_player_id", "round_id"], name: "index_answers_on_guessed_player_id_and_round_id", unique: true
    t.index ["guessed_player_id"], name: "index_answers_on_guessed_player_id"
    t.index ["player_id", "round_id"], name: "index_answers_on_player_id_and_round_id", unique: true
    t.index ["player_id"], name: "index_answers_on_player_id"
    t.index ["round_id"], name: "index_answers_on_round_id"
  end

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "user_id", null: false
    t.uuid "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["name", "game_id"], name: "index_players_on_name_and_game_id", unique: true
    t.index ["user_id", "game_id"], name: "index_players_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "rounds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id", null: false
    t.uuid "previous_id"
    t.integer "status", default: 0, null: false
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_rounds_on_player_id"
    t.index ["previous_id"], name: "index_rounds_on_previous_id", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "last_seen_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "players"
  add_foreign_key "answers", "players", column: "guessed_player_id"
  add_foreign_key "answers", "rounds"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
  add_foreign_key "rounds", "players"
  add_foreign_key "rounds", "rounds", column: "previous_id"
end
