SimpleCov.start do
  enable_coverage :branch
  cover "lib/**/*.rb"

  group "Errors", "lib/open_topo/errors"
  group "Net", "lib/open_topo/net"
  group "Services", "lib/open_topo/services"
end
