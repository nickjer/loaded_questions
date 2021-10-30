# frozen_string_literal: true

class Form
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include LogValidations
end
