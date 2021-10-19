# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :player
  belongs_to :round
end
