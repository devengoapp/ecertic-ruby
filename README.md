# Ecertic

This gem is a thin Ruby wrapper for the Ecertic OTP API <https://docs.otpsecure.net/>. It provides the

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ecertic'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install ecertic
```

## Usage

```ruby

require "ecertic"

client = Ecertic::Client.new(apikey: "APIKEY", secret: "SECRET")

info = {
  sandbox: true,
  movil: "669819258",
  smsusr: "selavon@fp",
  smspwd: "selavon01",
  pdf_files: [File.open("contract.pdf")],
}

request = client.otps.create(info)
# request.token => "d98509b2aa....3cff10a8b47"
# request.uuid => "rJwJnaKXS"
# In the sandbox environment you will get OTP number too
# request.otp => "147548"

status = client.otps.status(request.token)
# request.status => "SANDBOX"
# request.sandbox? => true
# request.sent? => false

validation = client.tokens.validate(request.token, request.otp)
# request.status => "OTP_OK"
# request.ok? => true
# request.message => "OTP CORRECTA"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/devengoapp/ecertic-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ecertic project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/devengoapp/ecertic-ruby/blob/master/CODE_OF_CONDUCT.md).
