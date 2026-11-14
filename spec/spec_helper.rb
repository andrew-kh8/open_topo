# frozen_string_literal: true

ENV["OPEN_TOPOGRAPHY_API_KEY"] ||= "OPEN_TOPOGRAPHY_API_KEY"

if ENV["COVERAGE"] == "true"
  require "simplecov"
  SimpleCov.start
end

require "open_topo"
require "support/vcr_setup"

require "factory_bot"

Dir["./spec/support/shared/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryBot::Syntax::Methods
end

FactoryBot.definition_file_paths = ["./spec/factories"]
FactoryBot.find_definitions
