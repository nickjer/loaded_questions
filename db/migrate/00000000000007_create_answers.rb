# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers, id: :uuid do |t|
      t.text :value, null: false
      t.references :participant, type: :uuid, index: { unique: true },
        foreign_key: true, null: false
      t.references :guessed_participant, type: :uuid, index: { unique: true },
        foreign_key: { to_table: :participants }

      t.timestamps
    end
  end
end
