SimpleCov.enable_coverage :branch
SimpleCov.cover "lib/**/*.rb"

# Loaded by Bundler through the gemspec before Coverage starts.
SimpleCov.skip "lib/open_topo/version.rb"

SimpleCov.group "Errors", "lib/open_topo/errors"
SimpleCov.group "Net", "lib/open_topo/net"
SimpleCov.group "Services", "lib/open_topo/services"

SimpleCov.coverage :line do
  minimum 90
  minimum_per_file 80
  # maximum_drop 5 # don't work without CI artefact
end

SimpleCov.coverage :branch do
  minimum 90
  # maximum_drop 5 # don't work without CI artefact
end
