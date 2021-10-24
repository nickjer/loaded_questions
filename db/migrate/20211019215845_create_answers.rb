# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.text :value, null: false
      t.references :player, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true
      t.references :guessed_player, index: true

      t.timestamps

      t.index %i[player_id round_id], unique: true
      t.index %i[guessed_player_id round_id], unique: true
    end
  end
end
