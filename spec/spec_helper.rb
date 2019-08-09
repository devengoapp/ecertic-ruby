require "bundler/setup"
require "rspec"
require "ecertic"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path(__dir__)
end

Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }
