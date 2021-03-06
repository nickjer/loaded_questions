# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :name
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :game, type: :uuid, null: false, foreign_key: true

      t.timestamps

      t.index %i[user_id game_id], unique: true
      t.index %i[name game_id], unique: true
    end
  end
end
