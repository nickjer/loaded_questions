# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # See https://github.com/ruby/debug/issues/336
  DEBUGGER__::CONFIG[:fork_mode] = :parent

  driven_by :selenium, using: :firefox, screen_size: [1400, 1400]
end
