# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds, id: :uuid do |t|
      t.references :player, type: :uuid, null: false, foreign_key: true
      t.references :previous, type: :uuid, index: { unique: true },
        foreign_key: { to_table: :rounds }
      t.integer :status, default: 0, null: false
      t.text :question

      t.timestamps
    end
  end
end
