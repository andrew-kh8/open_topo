# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday

  config.filter_sensitive_data("<OPEN_TOPOGRAPHY_API_KEY>") { ENV["OPEN_TOPOGRAPHY_API_KEY"] }
end
