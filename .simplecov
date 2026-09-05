SimpleCov.enable_coverage :branch
SimpleCov.cover "lib/**/*.rb"

SimpleCov.group "Errors", "lib/open_topo/errors"
SimpleCov.group "Net", "lib/open_topo/net"
SimpleCov.group "Services", "lib/open_topo/services"

SimpleCov.coverage :line do
  minimum 90
  maximum_drop 5
end
