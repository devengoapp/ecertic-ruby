# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ecertic/version"

Gem::Specification.new do |spec|
  spec.version       = Ecertic::VERSION
  spec.name          = "ecertic"
  spec.summary       = "Non-official Ruby bindings for the Ecertic API"
  spec.description   = "Ecertic provides digital signature and KYC services."
  spec.homepage      = "https://www.ecertic.com/"
  spec.authors       = ["Devengo"]
  spec.email         = ["dev@devengo.com"]
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.3.0"

  spec.metadata = {
    "homepage_uri"    => spec.homepage,
    "bug_tracker_uri" => "https://github.com/devengoapp/ecertic-ruby/issues",
    "changelog_uri"   => "https://github.com/devengoapp/ecertic-ruby/blob/master/CHANGELOG.md",
    "github_repo"     => "ssh://github.com/devengoapp/ecertic-ruby",
    "source_code_uri" => "https://github.com/devengoapp/ecertic-ruby",
  }

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("faraday", "~> 0.13")
  spec.add_runtime_dependency("faraday_middleware", "~> 0.13")
  spec.add_runtime_dependency("net-http-persistent", "~> 3.0")

  spec.add_development_dependency("bundler", "~> 2.0")
  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("rspec", "~> 3.0")
  spec.add_development_dependency("webmock", "~> 3.6")
  spec.add_development_dependency("guard", "~> 2.15")
  spec.add_development_dependency("guard-rspec", "~> 4.7")
end
