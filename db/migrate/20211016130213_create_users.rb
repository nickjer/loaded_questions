# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at, null: false
      t.datetime :last_sign_in_at, null: false

      t.timestamps
    end
  end
end
