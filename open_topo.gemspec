# frozen_string_literal: true

require_relative "lib/open_topo/version"

Gem::Specification.new do |spec|
  spec.name = "open_topo"
  spec.version = OpenTopo::VERSION
  spec.authors = ["andrew-kh8"]
  spec.email = ["horolskyandrey@gmail.com"]

  spec.summary = "Ruby Open Topography client"
  spec.description = "A simple Ruby client for interacting with the Open Topography API."
  spec.homepage = "https://github.com/andrew-kh8/open_topo"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.6"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andrew-kh8/open_topo"
  spec.metadata["changelog_uri"] = "https://github.com/andrew-kh8/open_topo/blob/master/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(
          "bin/", "Gemfile", ".gitignore", ".rspec", "spec/", ".github/", "docs/", ".standard.yml", ".fasterer.yml", ".simplecov", "README.md"
        )
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-validation", ">= 1.11"
  spec.add_dependency "faraday_middleware", ">= 1.2"
  spec.add_dependency "faraday", ">= 1.10"
  spec.add_dependency "multi_xml", ">= 0.9"
  spec.add_dependency "oj", ">= 3.17"
  spec.add_dependency "ox", ">= 2.14"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundle-audit"
  spec.add_development_dependency "factory_bot", "~> 6.6"
  spec.add_development_dependency "fasterer", "~> 0.11"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 1.1.1"
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "timecop", "~> 0.9"
  spec.add_development_dependency "vcr", "~> 6.4"
end
