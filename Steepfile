# D = Steep::Diagnostic
#
target :lib do
  signature "sig"
  check "lib"                       # Directory name
  ignore "lib/open_topo/net/params/contracts"
  library "date"
  library "open3"
  library "pathname"
  #   ignore_signature "sig/test"
  #
  #
  #   # RBSs for the gems in Gemfile.lock are loaded via rbs collection automatically.
  #   # Set it up with `rbs collection init` and `rbs collection install`.
  #   # library "monitor"               # Load an RBS that rbs collection doesn't manage
  #
  #   # configure_code_diagnostics(D::Ruby.default)      # `default` diagnostics setting (applies by default)
  #   # configure_code_diagnostics(D::Ruby.strict)       # `strict` diagnostics setting
  #   # configure_code_diagnostics(D::Ruby.lenient)      # `lenient` diagnostics setting
  #   # configure_code_diagnostics(D::Ruby.silent)       # `silent` diagnostics setting
  #   # configure_code_diagnostics do |hash|             # You can setup everything yourself
  #   #   hash[D::Ruby::NoMethod] = :information
  #   # end
end

# target :test do
#   unreferenced!                     # Skip type checking the `lib` code when types in `test` target is changed
#   signature "sig/test"              # Put RBS files for tests under `sig/test`
#   check "test"                      # Type check Ruby scripts under `test`
#
#   configure_code_diagnostics(D::Ruby.lenient)      # Weak type checking for test code
#
#   # library "monitor"               # Load an RBS that rbs collection doesn't manage
# end
