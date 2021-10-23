# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.references :player, null: false, foreign_key: true
      t.references :previous, index: { unique: true }
      t.integer :status, default: 0, null: false
      t.text :question

      t.timestamps
    end
  end
end
