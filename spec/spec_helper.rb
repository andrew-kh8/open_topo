# frozen_string_literal: true

require "open_topo"
require "support/vcr_setup"

require "factory_bot"
require "simplecov"

Dir["./spec/support/shared/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryBot::Syntax::Methods
end

FactoryBot.definition_file_paths = ["./spec/factories"]
FactoryBot.find_definitions
