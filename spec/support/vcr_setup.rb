# frozen_string_literal: true

require "vcr"

# Locally: record missing cassettes (existing cassettes are not overwritten).
# CI runs with COVERAGE=true and must replay existing cassettes only.
record_mode =
  if ENV["COVERAGE"] == "true"
    :none
  else
    :once
  end

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path("../fixtures/vcr_cassettes", __dir__)
  config.hook_into :faraday

  config.default_cassette_options = {
    record: record_mode,
    allow_unused_http_interactions: false
  }

  config.filter_sensitive_data("<OPEN_TOPOGRAPHY_API_KEY>") { ENV["OPEN_TOPOGRAPHY_API_KEY"] }
end
