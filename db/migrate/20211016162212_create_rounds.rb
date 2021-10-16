# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.text :question

      t.timestamps
    end
  end
end
