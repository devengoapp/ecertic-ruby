module RSpecHTTPFixtures

  def http_fixture(*names)
    File.join(SPEC_ROOT, "http.fixtures", *names)
  end

  def read_http_fixture(*names)
    File.read(http_fixture(*names))
  end

end

RSpec.configure do |config|
  config.include RSpecHTTPFixtures
end
